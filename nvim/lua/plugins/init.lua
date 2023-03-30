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
        keys = {
            {
                'w',
                function ()
                    require('spider').motion('w')
                end,
                desc = 'Move to next word',
                mode = {'n', 'o', 'x'},
            },
            {
                'e',
                function ()
                    require('spider').motion('e')
                end,
                desc = 'Move to end of word',
                mode = {'n', 'o', 'x'},
            },
            {
                'b',
                function ()
                    require('spider').motion('b')
                end,
                desc = 'Move to previous word',
                mode = {'n', 'o', 'x'},
            },
            {
                'ge',
                function ()
                    require('spider').motion('ge')
                end,
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
}
