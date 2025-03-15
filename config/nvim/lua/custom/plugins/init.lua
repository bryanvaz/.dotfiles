-- Throw any explicit dependencies in here
-- Also anything that you need to make sure 100%
-- runs before any other plugings and don't want to play
-- with priority

-- Require the themes file
local themes = require('custom.themes')

return {
    -- Critical Preloads
    { "nvim-lua/plenary.nvim", dev = false },

    -- Telescope: see ./telescope.lua

    --Treesitter: see ./treesitter.lua
    -- Settings in after/plugin/treesitter.lua

    -- Themes: activation in after/plugin/themes.lua
    --   { "rose-pine/neovim", name = "rose-pine" },
    --   { "catppuccin/nvim", name = "catppuccin" },
    -- { "baliestri/aura-theme",
    --   lazy = false,
    --   config = function(plugin)
    --     vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    --     vim.cmd([[colorscheme aura-dark]])
    --   end
    -- },
    { "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            themes.ActivateTokyo()  -- Call your custom function here
        end
    },

    -- UI
    { "nvim-lualine/lualine.nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true }
    },
    { "mbbill/undotree" },
    -- see neotree.lua
    { "akinsho/bufferline.nvim", version = "*", dependencies = "nvim-tree/nvim-web-devicons" },
    { 'Bekaboo/dropbar.nvim',
        -- optional, but required for fuzzy finder support
        dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' }
    },
    {
      'Aasim-A/scrollEOF.nvim',
      event = { 'CursorMoved', 'WinScrolled' },
      opts = {},
    },
    -- { "utilyre/barbecue.nvim",
    --     name = "barbecue",
    --     version = "*",
    --     dependencies = {    "SmiteshP/nvim-navic",
    --                         "nvim-tree/nvim-web-devicons", -- optional dependency
    --     },
    -- },
    -- Oil is disabled for now
    -- not behaving with netrw (empty directories)
    -- { 'stevearc/oil.nvim',
    --     dependencies = { "nvim-tree/nvim-web-devicons" },
    -- },
    { 'fedepujol/move.nvim', opts = {}},
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        -- config = function()
        --     require("nvim-surround").setup({
        --         -- Configuration here, or leave empty to use defaults
        --     })
        -- end
    },

    -- LSP
    --- Uncomment the two plugins below if you want to manage the language servers from neovim
    {'williamboman/mason.nvim'},
    {'williamboman/mason-lspconfig.nvim'},
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},
    {'hrsh7th/cmp-nvim-lsp'},
    {'hrsh7th/nvim-cmp'},
    {'L3MON4D3/LuaSnip'},

    -- Completion
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-nvim-lua" },
    { "onsails/lspkind-nvim" },
    { "saadparwaiz1/cmp_luasnip", dependencies = { "L3MON4D3/LuaSnip" } },
    { "tamago324/cmp-zsh" },

    -- Copilot
    { "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
    },
    { "zbirenbaum/copilot-cmp",
        config = function ()
            require("copilot_cmp").setup()
        end
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        branch = "main",
        dependencies = {
          { "zbirenbaum/copilot.lua" }, -- or github/copilot.vim
          { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
        },
        build = "make tiktoken", -- Only on MacOS or Linux
        opts = {
          debug = true, -- Enable debugging
          -- See Configuration section for rest
        },
        -- See Commands section for default commands if you want to lazy load on them
    },
    {
      "supermaven-inc/supermaven-nvim",
      lazy = false,
      -- config = function()
      --   require("supermaven-nvim").setup({})
      -- end,
    },
    {
      "yetone/avante.nvim",
      event = "VeryLazy",
      lazy = true,
      version = "*", -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
      opts = {
        provider = "copilot",
        copilot = {
          model = "claude-3.7-sonnet",
        },
        openai = {
          endpoint = "https://api.openai.com/v1",
          model = "gpt-4o",
        },
        claude = {
          model = "claude-3-7-sonnet-20250219",
        },
        -- add any opts here
        -- for example
        -- provider = "openai",
        -- openai = {
        --   endpoint = "https://api.openai.com/v1",
        --   model = "gpt-4o", -- your desired model (or use gpt-4o, etc.)
        --   timeout = 30000, -- timeout in milliseconds
        --   temperature = 0, -- adjust if needed
        --   max_tokens = 4096,
          -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
        -- },
      },
      -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
      build = "make",
      -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
      dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "stevearc/dressing.nvim",
        "nvim-lua/plenary.nvim",
        "MunifTanjim/nui.nvim",
        --- The below dependencies are optional,
        "echasnovski/mini.pick", -- for file_selector provider mini.pick
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
        "ibhagwan/fzf-lua", -- for file_selector provider fzf
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        "zbirenbaum/copilot.lua", -- for providers='copilot'
        {
          -- support for image pasting
          "HakonHarnes/img-clip.nvim",
          event = "VeryLazy",
          opts = {
            -- recommended settings
            default = {
              embed_image_as_base64 = false,
              prompt_for_file_name = false,
              drag_and_drop = {
                insert_mode = true,
              },
              -- required for Windows users
              use_absolute_path = true,
            },
          },
        },
        {
          -- Make sure to set this up properly if you have lazy=true
          'MeanderingProgrammer/render-markdown.nvim',
          opts = {
            file_types = { "markdown", "Avante" },
          },
          ft = { "markdown", "Avante" },
        },
      },
    }
}
