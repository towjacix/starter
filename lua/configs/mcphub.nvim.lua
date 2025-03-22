local hub = mcphub.get_hub_instance()

-- Call a tool (sync)
local response, err = hub:call_tool("server-name", "tool-name", {
    param1 = "value1"
}, {
    return_text = true -- Parse response to LLM-suitable text
})

-- Call a tool (async)
hub:call_tool("server-name", "tool-name", {
    param1 = "value1"
}, {
    return_text = true,
    callback = function(response, err)
        -- Use response
    end
})

-- Access resource (sync)
local response, err = hub:access_resource("server-name", "resource://uri", {
    return_text = true
})

-- Get prompt helpers for system prompts
local prompts = hub:get_prompts()
-- prompts.active_servers: Lists currently active servers
-- prompts.use_mcp_tool: Instructions for tool usage with example
-- prompts.access_mcp_resource: Instructions for resource access with example
