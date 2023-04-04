return {
    {'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = {'BufReadPost', 'BufNewFile'},
        opts = {
            ensure_installed = 'all',
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
            rainbow = {
                enable = true,
                query = {
                    'rainbow-parens',
                    html = 'rainbow-tags',
                },
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)

            -- Use treesitter for folding
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        end,
    },
    {'JoosepAlviste/nvim-ts-context-commentstring',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {'numToStr/Comment.nvim',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {
            pre_hook = function()
                require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            end,
        },
    },
    {'HiPhish/nvim-ts-rainbow2',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {'Wansmer/treesj',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            {
                '<Leader>st',
                '<cmd>TSJToggle<CR>',
                'Toggle treesitter block split/join',
            },
            {
                '<Leader>ss',
                '<cmd>TSJSplit<CR>',
                'Split treesitter block',
            },
            {
                '<Leader>sj',
                '<cmd>TSJJoin<CR>',
                'Join treesitter block',
            },
        },
    },
    {'nvim-treesitter/nvim-treesitter-context',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        config = true,
    },
    'jwalton512/vim-blade', -- No treesitter support for blade yet
    {'dense-analysis/ale',
        config = function()
            -- Wait a second for me to finish typing before linting
            vim.g.ale_lint_delay = 1000
            -- Show linter at beginning of message
            vim.g.ale_echo_msg_format = '[%linter%] %s'
            -- Show messages in a floating preview window
            vim.g.ale_cursor_detail = 1
            vim.g.ale_floating_preview = 1
            vim.g.ale_floating_window_border = {' ', '', '', '', '', '', '', ''}
            vim.g.ale_close_preview_on_insert = 1
            -- Don't show messages in virtual text
            vim.g.ale_virtualtext_cursor = 'disabled'
            -- ... or on the command line
            vim.g.ale_echo_cursor = 0
            -- Disable LSP features in ALE as these are handled by another plugin
            vim.g.ale_disable_lsp = 1
            -- Make ale error/warning gutter symbols prettier
            vim.g.ale_sign_error = '🙅'
            vim.g.ale_sign_warning = '🤨'
        end,
        event = {'BufReadPost', 'BufNewFile'},
        keys = {
            {
                '<Leader>j',
                '<Plug>(ale_previous_wrap)',
                desc = 'Move to the previous warning/error',
            },
            {
                '<Leader>k',
                '<Plug>(ale_next_wrap)',
                desc = 'Move to the next warning/error',
            },
            {
                '<Leader>ad',
                '<cmd>ALEDisable<CR>',
                desc = 'Disable ALE in all buffers',
            },
            {
                '<Leader>abd',
                '<cmd>ALEDisableBuffer<CR>',
                desc = 'Disable ALE in current buffer',
            },
            {
                '<Leader>ae',
                '<cmd>ALEEnable<CR>',
                desc = 'Enable ALE in all buffers',
            },
            {
                '<Leader>abe',
                '<cmd>ALEEnableBuffer<CR>',
                desc = 'Enable ALE in current buffer',
            },
        },
    },
}
