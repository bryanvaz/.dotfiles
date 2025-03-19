local harpoon = require('harpoon')
harpoon:setup({})

vim.keymap.set("n", "<C-p>", function()
    harpoon:list():add()
    print("File added to harpoon!")
end, { desc = "Add new harpoon mark" })
-- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)


-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-O>", function() harpoon:list():prev() end,
    { desc = "Prev buffer in harpoon" })
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():next() end,
    { desc = "Next buffer in harpoon" })


-- Telescope Extension for Harpoon
local conf = require("telescope.config").values
        local state = require("telescope.actions.state")

local function toggle_telescope(harpoon_files)
    local finder = function()
        local file_paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(file_paths, item.value)
        end

        return require("telescope.finders").new_table({
            results = file_paths,
        })
    end

    local delete_selected = function(prompt_bufnr)
        local selected_entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)

        table.remove(harpoon_files.items, selected_entry.index)
        current_picker:refresh(finder())
    end

    local move_selected_down = function(prompt_bufnr)
        local selected_entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)

        if not selected_entry then
            return
        end
        -- entries in picker are indexed in reverse order, so 1 is at the bottom
        if selected_entry.index == 1 then
            return
        end

        local mark = harpoon_files.items[selected_entry.index]
        table.insert(harpoon_files.items, selected_entry.index - 1, mark)
        table.remove(harpoon_files.items, selected_entry.index + 1)

        current_picker:refresh(finder())

        -- The other option is to modify telescope's table independently
        -- of harpoon_list. This has the remote chance of desyncing the 
        -- tow lists, and therefore not the greatest idea. Ideally,
        -- telescope refresh should provide the on_complete callback 
        -- as an option for refresh.
        vim.defer_fn(function()
            current_picker:set_selection(current_picker:get_selection_row() - (selected_entry.index - 2))
        end, 2)
    end

    local move_selected_up = function(prompt_bufnr)
        local selected_entry = state.get_selected_entry()
        local current_picker = state.get_current_picker(prompt_bufnr)
        local length = harpoon_files:length()

        if not selected_entry then
            return
        end
        -- entries in picker are indexed in reverse order, so 1 is at the bottom
        if selected_entry.index == length then
            return
        end

        local mark = harpoon_files.items[selected_entry.index]
        table.insert(harpoon_files.items, selected_entry.index + 2, mark)
        table.remove(harpoon_files.items, selected_entry.index)

        current_picker:refresh(finder())
        vim.defer_fn(function()
            current_picker:set_selection(current_picker:get_selection_row() - (selected_entry.index))
        end, 2)
    end


    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = finder(),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            map({ 'n', 'i' }, "<C-d>", delete_selected, { desc = "Delete entry from harpoon list" })
            map({ 'n', 'i' }, "<C-j>", move_selected_down, { desc = "Move entry down in harpoon list" })
            map({ 'n', 'i' }, "<C-k>", move_selected_up, { desc = "Move entry up in harpoon list" })
            return true
        end,
    }):find()
end
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })

