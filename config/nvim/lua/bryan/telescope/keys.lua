local builtin = require('telescope.builtin')
-- vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
-- vim.keymap.set('n', '<C-p>', builtin.git_files, {})

-- require("telescope").load_extension('harpoon')

-- Search
vim.keymap.set('n', '<leader>pw',
    function()
	    builtin.grep_string({
            word_match = "-w",
            short_path = true,
            only_sort_text = true,
            layout_strategy = "vertical",
            });
    end,
    { desc = "Telescope grep search word" }
)
vim.keymap.set('n', '<leader>ps', function()
	builtin.live_grep({
        -- word_match = "-w",
        -- short_path = true,
        -- only_sort_text = true,
        layout_strategy = "vertical",
        });
end,
    { desc = "telescope live grep" }
)
vim.keymap.set('n', '<leader>pd', function()
	builtin.resume({
        layout_strategy = "vertical",
        });
end,
    { desc = "Resume telescope" }
)
-- Files
vim.keymap.set('n', "<leader>pg", builtin.git_files, {desc = "telescope git files"})
-- vim.keymap.set('n', "<leader>pg", builtin.multi_rg, {})
vim.keymap.set('n', "<leader>po", builtin.oldfiles, {desc = "telescope previously opened files"})
vim.keymap.set('n', "<leader>pf", builtin.find_files, {desc = "telescope find files"})
-- vim.keymap.set('n', "<leader>pr",  function()
--     builtin.buffers({}); 
-- end,
--     {desc = "telescope buffers list"}
-- )
vim.keymap.set('n', "<leader>pr", function()
    builtin.buffers({
        attach_mappings = function(_, map)
            local actions = require('telescope.actions')
            map({ "i", "n" }, "<C-d>", actions.delete_buffer)
            return true
        end,
    })
end, { desc = "telescope buffers list" })
vim.keymap.set('n', "<leader>pe", builtin.diagnostics, {desc = "telescope lsp diagnostics"})
vim.keymap.set('n', "<leader>pc", builtin.lsp_references, {desc = "telescope lsp implementations"})

-- vim.keymap.set('n', "<leader>ps", builtin.fs, {})
-- vim.keymap.set('n', "<leader>pp", builtin.project_search, {})
-- vim.keymap.set('n', "<leader>pv", builtin.find_nvim_source, {})
-- vim.keymap.set('n', "<leader>pe", builtin.file_browser, {})
-- vim.keymap.set('n', "<leader>pz", builtin.search_only_certain_files, {})
