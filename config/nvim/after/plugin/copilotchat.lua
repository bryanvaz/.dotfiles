
local chat = require('CopilotChat')

local function toggle_chat()
    chat.toggle({
        window = {
            layout = "vertical",
            width = 0.35,
            title = "Copilot Chat",
        },
    })
end

vim.keymap.set('n', "<leader>mm", toggle_chat, {desc = "Toggle Copilot Chat"})
vim.keymap.set('x', "<leader>mm", toggle_chat, {desc = "Toggle Copilot Chat"})
