-- Based on TJ's config: 
-- https://github.com/tjdevries/config_manager/blob/master/xdg_config/nvim/lua/custom/plugins/telescope.lua
return {
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    priority = 100,
    config = function()
      require "bryan.telescope.setup"
      require "bryan.telescope.keys"
    end,
    -- dev = true,
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
--   "nvim-telescope/telescope-file-browser.nvim",
--   "nvim-telescope/telescope-hop.nvim",
--   "nvim-telescope/telescope-ui-select.nvim",
--   { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
--   {
--     "ThePrimeagen/git-worktree.nvim",
--     config = function()
--       require("git-worktree").setup {}
--     end,
--   },
--   {
--     "AckslD/nvim-neoclip.lua",
--     config = function()
--       require("neoclip").setup()
--     end,
--   },
}
