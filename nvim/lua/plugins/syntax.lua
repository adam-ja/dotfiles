---@type LazyPluginSpec[]|string[]
return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        lazy = false,
    },
    {
        ---@module 'treesitter-modules'
        'MeanderingProgrammer/treesitter-modules.nvim',
        dependencies = { 'nvim-treesitter/nvim-treesitter' },
        lazy = false,
        ---@type ts.mod.UserConfig
        opts = {
            -- These parsers must always be installed
            ensure_installed = {
                'c',
                'lua',
                'vim',
                'vimdoc',
                'query',
                'markdown',
                'markdown_inline',
            },
            -- Automatically install missing parsers when entering buffer
            auto_install = true,
            fold = { enable = true },
            highlight = { enable = true },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<CR>',
                    node_incremental = '<CR>',
                    node_decremental = '<BS>',
                },
            },
            indent = { enable = true },
        },
    },
    {
        ---@module 'Comment'
        'numToStr/Comment.nvim',
        dependencies = {
            {
                ---@module 'ts_context_commentstring
                'JoosepAlviste/nvim-ts-context-commentstring',
                ---@type ts_context_commentstring.Config
                opts = {
                    enable_autocmd = false,
                }
            },
        },
        config = function()
            ---@type CommentConfig
            opts = {
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
            }

            require('Comment').setup(opts)
        end,
    },
    'HiPhish/rainbow-delimiters.nvim',
    {
        'Wansmer/treesj',
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
        ---@module 'sibling-swap'
        'Wansmer/sibling-swap.nvim',
        ---@type UserOpts
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
    {
        'windwp/nvim-autopairs',
        opts = {
            check_ts = true,
        },
        event = 'InsertEnter',
    },
    {
        'windwp/nvim-ts-autotag',
        opts = {},
        ft = {
            'html',
            'xml',
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact',
            'blade',
            'twig',
            'vue',
            'markdown',
        },
    },
    {
        ---@module 'todo-comments'
        'folke/todo-comments.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
        },
        event = 'BufReadPost',
        ---@type TodoOptions
        opts = {
            highlight = {
                keyword = "bg",
                pattern = [[.*<(KEYWORDS)>]],
            },
            search = {
                pattern = [[\b(KEYWORDS)\b]],
            },
        },
        keys = {
            {
                '[t',
                function()
                    require('todo-comments').jump_prev()
                end,
                desc = 'Jump to the previous todo comment in the current buffer',
            },
            {
                ']t',
                function()
                    require('todo-comments').jump_next()
                end,
                desc = 'Jump to the next todo comment in the current buffer',
            },
        }
    },
}
