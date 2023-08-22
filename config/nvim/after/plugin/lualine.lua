
require('lualine').setup({
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

