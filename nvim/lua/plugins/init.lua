-- Core and miscelaneous plugins that don't fit in any other category
return {
    {'folke/lazy.nvim', -- let lazy.nvim manage itself
        version = '*',
    },
    {'iamcco/markdown-preview.nvim',
        ft = 'markdown',
        build = 'cd app && npm install',
    },
    'gpanders/editorconfig.nvim',
    'vim-scripts/SearchComplete',
    {'chrisgrieser/nvim-spider',
        keys = { -- Note cmd must be used instead of lua functions for dot-repeat to work
            {
                'w',
                [[<cmd>lua require('spider').motion('w')<CR>]],
                desc = 'Move to next word',
                mode = {'n', 'o', 'x'},
            },
            {
                'e',
                [[<cmd>lua require('spider').motion('e')<CR>]],
                desc = 'Move to end of word',
                mode = {'n', 'o', 'x'},
            },
            {
                'b',
                [[<cmd>lua require('spider').motion('b')<CR>]],
                desc = 'Move to previous word',
                mode = {'n', 'o', 'x'},
            },
            {
                'ge',
                [[<cmd>lua require('spider').motion('ge')<CR>]],
                desc = 'Move to end of previous word',
                mode = {'n', 'o', 'x'},
            },
        },
    },
    {'junegunn/vim-easy-align',
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
    {'embear/vim-localvimrc',
        init = function()
            -- Make the decisions given when asked before sourcing local vimrc files persistent over multiple vim runs
            -- and instances (only if the answer was given in upper case (Y/N/A))
            vim.g.localvimrc_persistent = 1
            -- Disable lvimrc sandbox so that lvimrc files can include potentially risky commands.
            -- This is safe so long as you trust the source of any repos with a lvimrc file.
            vim.g.localvimrc_sandbox = 0
            -- Search for local config files with these names
            vim.g.localvimrc_name = { '.lvimrc', '.local_init.lua' }
        end,
    },
    'arp242/auto_mkdir2.vim',
    {'jremmen/vim-ripgrep',
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
    {'nacro90/numb.nvim',
        config = true,
    },
    {'ziontee113/icon-picker.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            disable_legacy_commands = true,
        },
        keys = {
            {
                '<Leader>fi',
                '<cmd>IconPickerNormal<CR>',
                desc = 'Pick an icon',
            },
            {
                '<A-i>',
                '<cmd>IconPickerNormal<CR>',
                desc = 'Pick an icon',
                mode = 'i',
            },
        },
    },
    {'AckslD/nvim-neoclip.lua',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        opts = {
            keys = {
                telescope = {
                    i = {
                        paste_behind = '<C-S-p>', -- replace default <c-k> which is used to move up telescope results
                        delete = '<C-S-d>', -- delete an entry (replace default <c-d> which is used to scroll down telescope preview)
                    },
                },
            },
        },
        keys = {
            {
                '<Leader>c',
                function ()
                    require('telescope').extensions.neoclip['plus']()
                end,
                desc = 'Show yank history',
            },
            {
                '<Leader>m',
                function ()
                    require('telescope').extensions.macroscope.default()
                end,
                desc = 'Show macro history',
            },
        },
    },
}
