return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { 
                    "c",
                    "lua",
                    "vim",
                    "vimdoc",
                    "query",
                    "elixir",
                    "heex",
                    "javascript",
                    "html",
                    -- Go Lang features should be handled
                    -- by ray-x/go.nvim
                    "go",
                    -- "gotempl", -- for go template
                    "templ", -- for templ
                    "toml",
                    "sql",
                },
                sync_install = false,
                highlight = { enable = true },
                indent = { enable = true },
            })
        end
    },

--   { dir = "~/plugins/tree-sitter-lua" },
  "nvim-treesitter/playground",
--   "nvim-treesitter/nvim-treesitter-textobjects",
--   "JoosepAlviste/nvim-ts-context-commentstring",
--   "nvim-treesitter/nvim-treesitter-context",

  -- "vigoux/architext.nvim"
  -- {
  --     "mfussenegger/nvim-ts-hint-textobject",
  --     config = function()
  --       vim.cmd [[omap     <silent> m :<C-U>lua require('tsht').nodes()<CR>]]
  --       vim.cmd [[vnoremap <silent> m :lua require('tsht').nodes()<CR>]]
  --     end,
  --   }
}
