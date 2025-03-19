-- local telescope = require("telescope")
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

require("telescope").setup({
    defaults = {
        file_ignore_patterns = { "node_modules", ".git" },
        vimgrep_arguments = vimgrep_arguments,
        -- log_level = vim.log.levels.TRACE, -- Set log level to DEBUG
        -- log_file = "/Users/bryan/.local/share/nvim/telescope.log", -- Add this line
    },
    pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
		},
	},
})
