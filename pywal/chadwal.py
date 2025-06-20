#!/usr/bin/env python3

import json
import os
import subprocess
import sys
import time

from jinja2 import Environment, FileSystemLoader
from watchdog.events import FileSystemEventHandler
from watchdog.observers import Observer

# Constants
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
HOME_DIR = os.path.expanduser("~")

# The template to be rendered (matugen.lua)
TEMPLATE_TO_RENDER = os.path.join(SCRIPT_DIR, "matugen.lua")

# Where the rendered Lua theme will be placed for Neovim
RENDERED_THEME_DST = (
    f"{HOME_DIR}/.local/share/nvim/lazy/base46/lua/base46/themes/chadwal.lua"
)

# The source for the full color scheme JSON (pywal's output)
# Updated path for the colors.json file
COLORS_JSON_FILE = f"{HOME_DIR}/.local/state/quickshell/user/generated/colors.json"

FALLBACK_THEME = (
    f"{HOME_DIR}/.local/share/nvim/lazy/base46/lua/base46/themes/gruvchad.lua"
)
LOCK_FILE = "/tmp/wal_nvim_lock"

# Utility functions


def acquire_lock():
    """Create a lock file to prevent multiple instances."""
    if os.path.exists(LOCK_FILE):
        sys.exit("Another instance is already running. Exiting...")
    open(LOCK_FILE, "w").close()


def release_lock():
    """Remove the lock file."""
    if os.path.exists(LOCK_FILE):
        os.remove(LOCK_FILE)


def load_and_prepare_colors(json_path):
    """
    Loads the pywal colors.json and transforms it into the structure
    expected by the matugen.lua template ({{colors.KEY.default.hex}}).
    Also synthesizes common color names (red, green, blue etc.) from MD3 palette.
    """
    try:
        with open(json_path, "r") as file:
            raw_colors = json.load(file)
    except FileNotFoundError:
        sys.exit(
            f"Error: Colors JSON file not found: {json_path}. Run pywal first to generate it."
        )
    except json.JSONDecodeError:
        sys.exit(
            f"Error: Could not decode JSON from {json_path}. File might be corrupted."
        )

    # Transform all base colors to the nested {{colors.KEY.default.hex}} format
    transformed_colors = {k: {"default": {"hex": v}} for k, v in raw_colors.items()}

    # Synthesize common color names used in matugen.lua from the MD3 palette
    # These mappings are arbitrary and can be adjusted based on desired aesthetics.
    # The 'error' color from MD3 is a natural fit for 'red'.
    transformed_colors["red"] = transformed_colors.get(
        "error", transformed_colors["surface_tint"]
    )  # Fallback if error not found
    transformed_colors["baby_pink"] = transformed_colors.get(
        "error_container", transformed_colors["red"]
    )
    # 'pink' and 'purple' already map to 'tertiary' in matugen.lua directly.
    # 'green' is a logical mapping for 'tertiary'.
    transformed_colors["green"] = transformed_colors.get(
        "tertiary", transformed_colors["surface_tint"]
    )
    transformed_colors["vibrant_green"] = transformed_colors.get(
        "tertiary_fixed_variant", transformed_colors["green"]
    )

    # 'blue' and 'yellow' need mappings. Using 'primary' for 'blue' is a stretch
    # as primary is orange, but necessary if matugen expects it.
    transformed_colors["blue"] = transformed_colors.get(
        "primary", transformed_colors["surface_tint"]
    )
    transformed_colors["nord_blue"] = transformed_colors.get(
        "primary_container", transformed_colors["blue"]
    )
    transformed_colors["yellow"] = transformed_colors.get(
        "primary_fixed_dim", transformed_colors["surface_tint"]
    )
    transformed_colors["sun"] = transformed_colors.get(
        "primary_fixed_dim", transformed_colors["yellow"]
    )

    # 'cyan' is not directly available, mapping to secondary as a distinct color.
    transformed_colors["cyan"] = transformed_colors.get(
        "secondary", transformed_colors["surface_tint"]
    )

    # Ensure other matugen.lua specific keys exist in the transformed_colors structure,
    # even if they are just direct copies from the base MD3 keys.
    # This makes sure .get() calls in the template (if any) or direct lookups succeed.
    for key in [
        "background",
        "on_background",
        "surface_variant",
        "outline",
        "on_surface_variant",
        "on_surface",
        "surface",
        "secondary_container",
        "tertiary",
        "primary_fixed_dim",
        "inverse_surface",
    ]:
        if key not in transformed_colors and key in raw_colors:
            transformed_colors[key] = {"default": {"hex": raw_colors[key]}}

    return {"colors": transformed_colors}


def render_and_save_template():
    """Loads the template, renders it with colors, and saves the output."""
    try:
        # Set up Jinja2 environment to load template from current script directory
        env = Environment(loader=FileSystemLoader(SCRIPT_DIR))
        template = env.get_template(os.path.basename(TEMPLATE_TO_RENDER))

        # Load and prepare colors from pywal's colors.json
        template_context = load_and_prepare_colors(COLORS_JSON_FILE)

        # Ensure the destination directory exists
        os.makedirs(os.path.dirname(RENDERED_THEME_DST), exist_ok=True)

        # Render the template
        rendered_content = template.render(template_context)

        # Save the rendered content to the destination
        with open(RENDERED_THEME_DST, "w") as f:
            f.write(rendered_content)
        print(f"Template rendered and saved to {RENDERED_THEME_DST}.")

    except Exception as e:
        sys.exit(f"Error rendering template: {e}")

    # Signal running nvim instances
    subprocess.run(["killall", "-SIGUSR1", "nvim"])


# Watchdog event handler


class ColorsFileHandler(FileSystemEventHandler):
    def on_modified(self, event):
        # Only react to the specific colors.json file being modified
        if event.src_path == COLORS_JSON_FILE:
            print(f"Detected change in {COLORS_JSON_FILE}. Re-rendering theme...")
            render_and_save_template()


def monitor_file(file_path):
    """Monitor the specified file for changes."""
    event_handler = ColorsFileHandler()
    observer = Observer()
    observer.schedule(event_handler, os.path.dirname(file_path), recursive=False)
    observer.start()

    try:
        while True:
            # Check every 5 seconds if nvim is running
            time.sleep(5)
            # Use pgrep to check for exact process name 'nvim'
            result = subprocess.run(["pgrep", "-x", "nvim"], capture_output=True)
            if result.returncode != 0:
                print("No running nvim instances found. Exiting.")
                observer.stop()  # Stop the observer thread
                break  # Exit the loop
    except KeyboardInterrupt:
        print("\nKeyboard interrupt received. Exiting.")
        observer.stop()
    finally:
        # Ensure the observer thread is joined before exiting
        observer.join()


if __name__ == "__main__":
    acquire_lock()
    try:
        # Perform an initial render when the script starts
        render_and_save_template()
        # Then start monitoring for changes to the colors.json
        monitor_file(COLORS_JSON_FILE)
    finally:
        release_lock()
