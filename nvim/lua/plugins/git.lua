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
    },
}
