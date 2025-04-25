return {
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = { 'BufReadPost', 'BufNewFile' },
        opts = {
            ensure_installed = 'all',
            auto_install = true,
            highlight = {
                enable = true,
            },
            indent = {
                enable = true,
            },
        },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup(opts)

            -- Use treesitter for folding
            vim.opt.foldmethod = 'expr'
            vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
        end,
    },
    {
        'JoosepAlviste/nvim-ts-context-commentstring',
        opts = {
            enable_autocmd = false,
        }
    },
    {
        'numToStr/Comment.nvim',
        dependencies = {
            'JoosepAlviste/nvim-ts-context-commentstring',
        },
        opts = {
            pre_hook = function()
                require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            end,
        },
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
    },
    {
        'Wansmer/treesj',
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
                desc = 'Toggle treesitter block split/join',
            },
            {
                '<Leader>ss',
                '<cmd>TSJSplit<CR>',
                desc = 'Split treesitter block',
            },
            {
                '<Leader>sj',
                '<cmd>TSJJoin<CR>',
                desc = 'Join treesitter block',
            },
        },
    },
    {
        'Wansmer/sibling-swap.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {
            use_default_keymaps = false,
        },
        keys = {
            {
                '<Leader>,',
                function()
                    require('sibling-swap').swap_with_left()
                end,
                desc = 'Swap with sibling to the left (`a, _b_, c` becomes `_b_, a, c`, `5 > _3_` becomes `_3_ > 5`)',
            },
            {
                '<Leader><M-,>',
                function()
                    require('sibling-swap').swap_with_left_with_opp()
                end,
                desc = 'Swap with sibling to the left including operator (`5 > _3_` becomes `_3_ < 5`)',
            },
            {
                '<Leader>.',
                function()
                    require('sibling-swap').swap_with_right()
                end,
                desc = 'Swap with sibling to the right (`a, _b_, c` becomes `a, c, _b_`, `_5_ > 3` becomes `3 > _5_`)',
            },
            {
                '<Leader><M-.>',
                function()
                    require('sibling-swap').swap_with_right_with_opp()
                end,
                desc = 'Swap with sibling to the right including operator (`_5_ > 3` becomes `3 < _5_`)',
            },
        },
    },
    'jwalton512/vim-blade', -- No treesitter support for blade yet
    {
        'windwp/nvim-autopairs',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'hrsh7th/nvim-cmp',
        },
        config = function()
            require('nvim-autopairs').setup({
                check_ts = true,
            })

            -- Insert `(` after selecting a function/method from the completion menu
            local cpm_autopairs = require('nvim-autopairs.completion.cmp')
            local cmp = require('cmp')
            cmp.event:on('confirm_done', cpm_autopairs.on_confirm_done())
        end,
        event = 'InsertEnter',
    },
    {
        'windwp/nvim-ts-autotag',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
        },
        opts = {},
        event = 'InsertEnter',
    },
    {
        'folke/todo-comments.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        event = 'BufReadPost',
        opts = {
            highlight = {
                keyword = "bg",
                pattern = [[.*<(KEYWORDS)>]],
            },
            search = {
                pattern = [[\b(KEYWORDS)\b]],
            },
        },
    },
}
