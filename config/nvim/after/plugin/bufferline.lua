
function ActivateBufferLine()
  require('bufferline').setup{
    options = {
        -- numbers = "ordinal",
        -- number_style = "superscript",
        diagnostics = "nvim_lsp",
        -- diagnostics_indicator = function(count, level, diagnostics_dict, context)
        --   return "(" .. count .. ")"
        -- end,
        -- show_buffer_close_icons = false,
        -- show_close_icon = false,
        -- show_tab_indicators = true,
        separator_style = "thin",
        -- always_show_bufferline = false,
        -- max_name_length = 18,
        -- max_prefix_length = 15,
        -- tab_size = 18,
        -- enforce_regular_tabs = false,
        -- view = "multiwindow",
        indicator = {
            style = "underline",
        },
        -- offsets = {
        --   {
        --     filetype = "NvimTree",
        --     text = "File Explorer",
        --     highlight = "Directory",
        --     text_align = "center"
        --   }
        -- }
        hover = {
            enabled = true,
            delay = 200,
            reveal = {'close'}
        },
    }
  }
end

ActivateBufferLine()
