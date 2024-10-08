local harpoon = require("harpoon")

-- REQUIRED
harpoon:setup()
-- REQUIRED

vim.keymap.set("n", "<C-p>",
    function()
        harpoon:list():append()
        print("File added to harpoon!")
    end,
    { desc = "Add new harpoon mark" }
)
-- vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end)
-- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
local keys = {
    {"<C-h>", 1},
    {"<C-j>", 2},
    {"<C-k>", 3},
    {"<C-l>", 4},
}
for _, value in ipairs(keys) do
    for _, mode in ipairs({'n', 'x', 'i'}) do
        vim.keymap.set(mode, value[1], function() harpoon:list():select(value[2]) end,
            { desc = "Harpoon to Mark " .. value[2] })
    end
end

-- Toggle previous & next buffers stored within Harpoon list
vim.keymap.set("n", "<C-S-P>", function() harpoon:list():prev() end,
    { desc = "Prev buffer in harpoon" })
vim.keymap.set("n", "<C-S-N>", function() harpoon:list():next() end,
    { desc = "Next buffer in harpoon" })



-- Telescope configuration
local conf = require("telescope.config").values
local pickers = require("telescope.pickers")
local themes = require("telescope.themes")
local finders = require("telescope.finders")
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local action_utils = require("telescope.actions.utils")

local function generate_new_finder(harpoon_files)
    local files = {}
    for i, item in ipairs(harpoon_files.items) do
        table.insert(files, i .. ". " .. item.value)
    end

    return finders.new_table({
        results = files,
    })
end

-- move_mark_up will move the mark up in the list, refresh the picker's result list and move the selection accordingly
local function move_mark_up(prompt_bufnr, harpoon_files)
    local selection = action_state.get_selected_entry()
    if not selection then
        return
    end
    if selection.index == 1 then
        return
    end

    local mark = harpoon_files.items[selection.index]

    table.remove(harpoon_files.items, selection.index)
    table.insert(harpoon_files.items, selection.index - 1, mark)

    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:refresh(generate_new_finder(harpoon_files), {})

    -- yes defer_fn is an awful solution. If you find a better one, please let the world know.
    -- it's used here because we need to wait for the picker to refresh before we can set the selection
    -- actions.move_selection_previous() doesn't work here because the selection gets reset to 0 on every refresh.
    vim.defer_fn(function()
        -- don't even bother finding out why this is -2 here. (i don't know either)
        current_picker:set_selection(selection.index - 2)
    end, 2) -- 2ms was the minimum delay I could find that worked without glitching out the picker
end

-- move_mark_down will move the mark down in the list, refresh the picker's result list and move the selection accordingly
local function move_mark_down(prompt_bufnr, harpoon_files)
    local selection = action_state.get_selected_entry()
    if not selection then
        return
    end

    local length = harpoon:list():length()
    if selection.index == length then
        return
    end

    local mark = harpoon_files.items[selection.index]

    table.remove(harpoon_files.items, selection.index)
    table.insert(harpoon_files.items, selection.index + 1, mark)

    local current_picker = action_state.get_current_picker(prompt_bufnr)
    current_picker:refresh(generate_new_finder(harpoon_files), {})

    -- yes defer_fn is an awful solution. If you find a better one, please let the world know.
    -- it's used here because we need to wait for the picker to refresh before we can set the selection
    -- actions.move_selection_next() doesn't work here because the selection gets reset to 0 on every refresh.
    vim.defer_fn(function()
        current_picker:set_selection(selection.index)
    end, 2) -- 2ms was the minimum delay I could find that worked without glitching out the picker
end

local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    local finder = function()
        local paths = {}
        for _, item in ipairs(harpoon_files.items) do
            table.insert(paths, item.value)
        end

        return require("telescope.finders").new_table({
            results = paths,
        })
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = finder(),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(_, map)
            -- Delete entries in insert mode from harpoon list with <C-d>
            -- Change the keybinding to your liking
            map({ 'n', 'i' }, '<C-d>', function(prompt_bufnr)
                local state = require("telescope.actions.state")
                local selected_entry = state.get_selected_entry()
                local current_picker = state.get_current_picker(prompt_bufnr)

                table.remove(harpoon_files.items, selected_entry.index)
                current_picker:refresh(finder())

                -- local curr_picker = action_state.get_current_picker(prompt_bufnr)

                -- curr_picker:delete_selection(function(selection)
                --     harpoon:list():removeAt(selection.index)
                -- end,
                -- { desc = "Delete entry from harpoon list" })
            end)
            -- Move entries up and down with <C-j> and <C-k>
            -- Change the keybinding to your liking
            map({ 'n', 'i' },
                '<C-j>',
                function(prompt_bufnr)
                    move_mark_down(prompt_bufnr, harpoon_files)
                end,
                { desc = "Move entry down in harpoon list" }
            )
            map({ 'n', 'i' },
                '<C-k>',
                function(prompt_bufnr)
                    move_mark_up(prompt_bufnr, harpoon_files)
                end,
                { desc = "Move entry up in harpoon list" }
            )

            return true
        end,
    }):find()
end

vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window" })
