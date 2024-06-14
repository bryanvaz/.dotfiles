
-- Bring Mason online first to install LSPs
-- here you can setup the language servers 
-- TODO: Should really be in own file, but can't be be
-- 	 bothered to figure out how to define load order
require("mason").setup()
local mason_lspconfig = require("mason-lspconfig")
mason_lspconfig.setup {
	ensure_installed = {
		"tsserver",
		"eslint",
		"lua_ls",
		-- "rust_analyzer",
		"gopls",
        "templ",
		-- "ocamllsp",
        -- "volar",
        -- "tailwindcss",
        "pyright",
	},
}

local lsp_zero = require('lsp-zero')
local lspkind = require('lspkind')

lspkind.init {
  symbol_map = {
    Copilot = "",
  },
}
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

-- Enable Copilot but delegate to cmp
require('copilot').setup({
  suggestion = {enabled = false},
  panel = {enabled = false},
})
require('copilot_cmp').setup()

-- Setup cmp completions
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}
cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end,
    },
    window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-[>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-]>'] = cmp.mapping.select_next_item(cmp_select),
        ["<C-'>"] = cmp.mapping.scroll_docs(-4),
        ["<C-;>"] = cmp.mapping.scroll_docs(4),
        ['<Esc>'] = cmp.mapping.abort(),
        ["<C-y>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Insert,
                select = true,
            },
            { "i", "c" }
        ),
        ["<M-y>"] = cmp.mapping(
            cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            },
            { "i", "c" }
        ),
        ["<C-Space>"] = cmp.mapping.complete(),

        ["<tab>"] = cmp.config.disable,
    }),
    sources = cmp.config.sources({
        { name = "nvim_lua" },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "copilot" },
    }, {
        { name = "path" },
        { name = "buffer", keyword_length = 5 },
    }),
    formatting = {
        format = lspkind.cmp_format {
            with_text = true,
            menu = {
                buffer = "[buf]",
                nvim_lsp = "[LSP]",
                nvim_lua = "[api]",
                path = "[path]",
                luasnip = "[snip]",
                gh_issues = "[issues]",
                tn = "[TabNine]",
            },
        },
    },
    experimental = {
        native_menu = false, -- I like the new menu better! Nice work hrsh7th
        ghost_text = true, -- Let's play with this for a day or two
    },
})

lsp_zero.on_attach(function(client, bufnr)
  -- see :help lsp-zero-keybindings
  -- to learn the available actions
    lsp_zero.default_keymaps({buffer = bufnr})
    local opts = {buffer = bufnr, remap = false}


    -- Default keymap
    -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    -- vim.keymap.set("n", "gl", function() vim.diagnostic.open_float() end, opts)
    -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)

    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end,
        {buffer = bufnr, remap = false,
        desc = "Workspace Symbol"})

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)

    -- Not needed. Should be bound to "gd"
    -- vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    -- vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    -- vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

-- here you can setup the language servers 
-- TODO: Should really be in own file, but can't be be
-- 	 bothered to figure out how to define load order
mason_lspconfig.setup {
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            -- (Optional) Configure lua language server for neovim
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)

            -- Configure golang lsp (gopls)
        end,
    }
}


vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.go",
    callback = function()
        vim.lsp.buf.format(nil, 1000)
    end,
})
