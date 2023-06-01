return {
    'tpope/vim-fugitive',
    {'lewis6991/gitsigns.nvim',
        opts = {
            numhl = true,
            current_line_blame = true,
            current_line_blame_opts = {
                virt_text_pos = 'eol',
                delay = 500,
            },
            current_line_blame_formatter = '      <author>, <author_time:%Y-%m-%d>  <summary>',
            current_line_blame_formatter_nc = '      Not committed yet',
        },
        event = 'BufRead',
        keys = {
            {
                '<Leader>gj',
                function()
                    require('gitsigns').next_hunk()
                end,
                desc = 'Go to next hunk [gitsigns]',
            },
            {
                '<Leader>gk',
                function ()
                    require('gitsigns').prev_hunk()
                end,
                desc = 'Go to previous hunk [gitsigns]',
            },
            {
                '<Leader>gp',
                -- TODO: make util function for pausing diagnostics hover (see lsp documentation keymap)
                function ()
                    require('gitsigns').preview_hunk()
                end,
                desc = 'Preview hunk [gitsigns]',
            },
            {
                '<Leader>gtb',
                function ()
                    require('gitsigns').toggle_current_line_blame()
                end,
                desc = 'Toggle current line blame [gitsigns]',
            },
            {
                '<Leader>gtd',
                function ()
                    require('gitsigns').toggle_deleted()
                end,
                desc = 'Toggle display of deleted lines [gitsigns]',
            },
            {
                '<Leader>gs',
                function ()
                    require('gitsigns').stage_hunk()
                end,
                desc = 'Stage current hunk [gitsigns]',
            },
            {
                '<Leader>gs',
                function ()
                    require('gitsigns').stage_hunk({vim.fn.line('.'), vim.fn.line('v')})
                end,
                desc = 'Stage selected lines from hunk [gitsigns]',
                mode = 'v',
            },
            {
                '<Leader>gS',
                function ()
                    require('gitsigns').stage_buffer()
                end,
                desc = 'Stage all hunks in buffer [gitsigns]',
            },
            {
                '<Leader>gu',
                function ()
                    require('gitsigns').undo_stage_hunk()
                end,
                desc = 'Undo last stage hunk [gitsigns]',
            },
            {
                '<Leader>gr',
                function ()
                    require('gitsigns').reset_hunk()
                end,
                desc = 'Reset current hunk [gitsigns]',
            },
            {
                '<Leader>gr',
                function ()
                    require('gitsigns').reset_hunk({vim.fn.line('.'), vim.fn.line('v')})
                end,
                desc = 'Reset selected lines from hunk [gitsigns]',
                mode = 'v',
            },
            {
                '<Leader>gR',
                function ()
                    require('gitsigns').reset_buffer()
                end,
                desc = 'Reset all hunks in buffer [gitsigns]',
            },
            {
                '<Leader>gd',
                function ()
                    require('gitsigns').diffthis()
                end,
                desc = 'Diff current file [gitsigns]',
            },
        }
    },
}
