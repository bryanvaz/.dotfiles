
-- vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- Move to window using the <ctrl> hjkl keys
vim.keymap.set("n", "<C-9>", "<C-w>h", { desc = "Move to window left" })
vim.keymap.set("x", "<C-9>", "<C-w>h", { desc = "Move to window left" })
vim.keymap.set("n", "<C-0>", "<C-w>l", { desc = "Move to window right" })
vim.keymap.set("x", "<C-0>", "<C-w>l", { desc = "Move to window right" })
-- vim.keymap.set("n", "<C-h>", "<C-w>h")
-- vim.keymap.set("n", "<C-j>", "<C-w>j")
-- vim.keymap.set("n", "<C-k>", "<C-w>k")
-- vim.keymap.set("n", "<C-l>", "<C-w>l")

-- remap comment
local line_rhs = function()
      return require('vim._comment').operator() .. '_'
    end
vim.keymap.set('n', '<C-/>', line_rhs, { expr = true, desc = 'Toggle comment line' })
local operator_rhs = function()
  return require('vim._comment').operator()
end
vim.keymap.set({ 'v' }, '<C-/>', operator_rhs, { expr = true, desc = 'Toggle comment line' })
