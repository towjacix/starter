local mason, nvim_dap = require('mason'), require("mason-nvim-dap")
local dap, dapui = require("dap"), require("dapui")

nvim_dap.setup({
  ensure_installed = {"python", "cppdgb"},
  automatic_installation = true,
  handlers = {},
})

require("dapui").setup()

dap.listeners.before.attach.dapui_config = function()
  dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
  dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
  dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
  dapui.close()
end


