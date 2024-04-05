--[[
    Config based on: https://github.com/tjdevries/config_manager

Much of the configuration of individual plugins you can find in either:

./plugin/*.lua
  This is where many of the new plugin configurations live.

./after/plugin/*.vim
  This is where configuration for plugins live.

  They get auto sourced on startup. In general, the name of the file configures
  the plugin with the corresponding name.

./lua/bryan/*.lua
  This is where configuration/extensions for new style plugins live.

  They don't get sourced automatically, but do get sourced by doing something like:

    require('bryan.dap')

  or similar. I generally recommend that people do this so that you don't accidentally
  override any of the plugin requires with namespace clashes. So don't just put your configuration
  in "./lua/dap.lua" because then it will override the plugin version of "dap.lua"

--]]

-- Todo: set up globals that might be used in other files

-- Leader key -> ","
--
-- In general, it's a good idea to set this early in your config, because otherwise
-- if you have any mappings you set BEFORE doing this, they will be set to the OLD
-- leader.
vim.g.mapleader = " "
vim.g.maplocalleader = " "
require "bryan.remap"
require "bryan.options"

-- Turn off builtin plugins I do not use.
-- require "tj.disable_builtin"

require "bryan.lazy"