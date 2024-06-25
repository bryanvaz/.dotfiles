
function ActivateNeoTree()
    require("neo-tree").setup({
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "NC",
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = false,
                hide_hidden = false,
            },
            bind_to_cwd = false,
            follow_current_file = { enabled = true },
            use_libuv_file_watcher = true,
            hijack_netrw_behavior = "disabled",
            check_gitignore_in_search = false,
        },
        default_component_configs = {
            indent = { 
                with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
            },
        },
    })

    -- local toggle = function()
    --     vim.cmd([[Neotree filesystem left toggle]])
    -- end

    local toggle_float = function()
        -- vim.cmd([[Neotree filesystem float toggle]])
        require("neo-tree.command").execute({ 
            source = "filesystem", 
            toggle = true,
            position = "float",
        })
    end

    -- local file_explorer = function()
    --     require("neo-tree.command").execute({ 
    --         source = "filesystem", 
    --         toggle = true,
    --         position = "float",
    --     })
    -- end
    local git_explorer = function()
        require("neo-tree.command").execute({ 
            source = "git_status", 
            toggle = true,
            position = "float",
        })
    end
    local buffer_explorer = function()
        require("neo-tree.command").execute({
            source = "buffers",
            toggle = true,
            position = "float",
        })
    end

    vim.keymap.set("n", "<C-b>", toggle_float)
    vim.keymap.set("n", "<leader>oo", toggle_float)
    -- vim.keymap.set("n", "<leader>of", file_explorer)
    vim.keymap.set("n", "<leader>og", git_explorer)
    vim.keymap.set("n", "<leader>or", buffer_explorer)

end

ActivateNeoTree()




