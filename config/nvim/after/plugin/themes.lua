
function ActivateRosePine(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

end

-- ActivateRosePine(color)

-- Catppuchinn custom
function ActivateCatppuccinCustom(color)
    require("catppuccin").setup {
		flavor = "mocha",
		term_colors = false,
		-- transparent_background = true,
		styles = {
			comments = {},
			conditionals = {},
			loops = {},
			functions = {},
			keywords = {},
			strings = {},
			variables = {},
			numbers = {},
			booleans = {},
			properties = {},
			types = {},
		},
        color_overrides = {
            mocha = {
                -- base = "#000000",
                -- mantle = "#000000",
                -- crust = "#000000",
            },
        },
        integrations = {
            treesitter = true,
			telescope = {
				enabled = true,
				-- style = "nvchad"
			},
			-- harpoon = false,
			native_lsp = {
				enabled = true,
				virtual_text = {
					errors = { "italic" },
					hints = { "italic" },
					warnings = { "italic" },
					information = { "italic" },
				},
				underlines = {
					errors = { "underline" },
					hints = { "underline" },
					warnings = { "underline" },
					information = { "underline" },
				},
				inlay_hints = {
					background = true,
				},
			},
        },
    }
    color = color or "catppuccin"
	vim.cmd.colorscheme(color)
end

-- ActivateCatppuccinCustom(color)

function AuraColor(color) 
	color = color or "aura-dark"
	vim.cmd.colorscheme(color)
end

-- AuraColor(color)

function ActivateTokyo(style)
    require("tokyonight").setup {
        style = style or "night",
        transparent = true,
        italic_comments = true,
        -- dark_sidebar = true,
        -- dark_float = true,
        -- sidebars = { "qf", "vista_kind", "terminal", "packer" },
        -- colors = { hint = "orange", error = "#ff0000" },
    }
    color = color or "tokyonight"
    vim.cmd.colorscheme(color)
end

ActivateTokyo()