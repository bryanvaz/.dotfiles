
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

vim.api.nvim_set_keymap('n', '<C-[>', '<C-w>h', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-]>', '<C-w>l', { noremap = true })


