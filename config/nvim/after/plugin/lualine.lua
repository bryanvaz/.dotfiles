
require('lualine').setup({
    options = {
        theme = 'tokyonight',
        -- section_separators = {'', ''},
        -- component_separators = {'', ''},
    },
    sections = {
        lualine_c = {
            'filename',
            {
                'buffers',
                mode = 2,
            },
        },
    },
})

