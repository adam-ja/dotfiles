-- Core and miscelaneous plugins that don't fit in any other category
return {
    {
        'folke/lazy.nvim', -- let lazy.nvim manage itself
        version = '*',
    },
    {
        'chrisgrieser/nvim-spider',
        keys = { -- Note cmd must be used instead of lua functions for dot-repeat to work
            {
                'w',
                [[<cmd>lua require('spider').motion('w')<CR>]],
                desc = 'Move to next word',
                mode = { 'n', 'o', 'x' },
            },
            {
                'e',
                [[<cmd>lua require('spider').motion('e')<CR>]],
                desc = 'Move to end of word',
                mode = { 'n', 'o', 'x' },
            },
            {
                'b',
                [[<cmd>lua require('spider').motion('b')<CR>]],
                desc = 'Move to previous word',
                mode = { 'n', 'o', 'x' },
            },
            {
                'ge',
                [[<cmd>lua require('spider').motion('ge')<CR>]],
                desc = 'Move to end of previous word',
                mode = { 'n', 'o', 'x' },
            },
        },
    },
    {
        'junegunn/vim-easy-align',
        keys = {
            {
                '<F2>',
                '<Plug>(EasyAlign)',
                desc   = 'Align text',
                silent = false,
                mode   = 'v',
            }
        },
    },
    'tpope/vim-repeat',
    'tpope/vim-surround',
    'tpope/vim-speeddating',
    'tpope/vim-abolish',
    {
        'jremmen/vim-ripgrep',
        config = function()
            -- Configure options to pass to ripgrep when using the :Rg command
            vim.g.rg_command = 'rg --vimgrep --smart-case --follow --ignore-vcs --color=never'
        end,
        cmd = 'Rg',
        keys = {
            {
                '<Leader>r',
                '<cmd>Rg<Space>',
                desc = 'ripgrep search within files under working directory (results open in quickfix window)',
                silent = false,
            },
            {
                '<Leader>R',
                [[<cmd>:Rg<Space>expand('<cword>')<CR>]],
                desc = 'ripgrep search for word under cursor',
                expr = true,
            },
        },
    },
    'stefandtw/quickfix-reflector.vim',
    {
        'nacro90/numb.nvim',
        opts = {},
    },
    {
        'AckslD/nvim-neoclip.lua',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            keys = {
                telescope = {
                    i = {
                        paste_behind = '<C-S-p>', -- replace default <c-k> which is used to move up telescope results
                        delete = '<C-S-d>',       -- delete an entry (replace default <c-d> which is used to scroll down telescope preview)
                    },
                },
            },
        },
        keys = {
            {
                '<Leader>c',
                function()
                    require('telescope').extensions.neoclip['plus']()
                end,
                desc = 'Show yank history',
            },
            {
                '<Leader>m',
                function()
                    require('telescope').extensions.macroscope.default()
                end,
                desc = 'Show macro history',
            },
        },
    },
    {
        'folke/persistence.nvim',
        event = 'BufReadPre',
        opts = {},
    },
}
