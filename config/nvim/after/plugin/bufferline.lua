
function ActivateBufferLine()
    local bufferline = require('bufferline')
    bufferline.setup({
      options = {
          -- numbers = "buffer_id",
          -- numbers = function(opts) return string.format('%s', opts.raise(opts.id)) end,
          -- numbers = function(opts) return string.format('%s', opts.raise(opts.ordinal)) end,
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
              reveal = {'close'},
          },
      },
    })

    vim.keymap.set('n', "<C-9>", function() bufferline.cycle(-1) end, {desc = "cycle bufferline backwards"})
    vim.keymap.set('x', "<C-9>", function() bufferline.cycle(-1) end, {desc = "cycle bufferline backwards"})
    vim.keymap.set('i', "<C-9>", function() bufferline.cycle(-1) end, {desc = "cycle bufferline backwards"})
    vim.keymap.set('n', "<C-0>", function() bufferline.cycle(1) end, {desc = "cycle bufferline forwards"})
    vim.keymap.set('x', "<C-0>", function() bufferline.cycle(1) end, {desc = "cycle bufferline forwards"})
    vim.keymap.set('i', "<C-0>", function() bufferline.cycle(1) end, {desc = "cycle bufferline forwards"})
    -- vim.keymap.set('n', "<C-w>", ":bdelete<CR>", {desc = "delete buffer"})
end

ActivateBufferLine()


