return {
    {
        'nvim-treesitter/nvim-treesitter',
        branch = 'main',
        build = ':TSUpdate',
        lazy = false,
        config = function()
            -- Install all available parsers
            require('nvim-treesitter').install(require('nvim-treesitter.config').get_available()):wait(300000)

            vim.api.nvim_create_autocmd('FileType', {
                pattern = '*',
                callback = function(args)
                    local filetype = args.match
                    local parser_name = vim.treesitter.language.get_lang(filetype)

                    if not parser_name then
                        return
                    end

                    if not pcall(vim.treesitter.get_parser, args.buf, parser_name) then
                        return
                    end

                    vim.treesitter.start()

                    vim.wo.foldmethod = 'expr'
                    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'

                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        'numToStr/Comment.nvim',
        dependencies = {
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
                opts = {
                    enable_autocmd = false,
                }
            },
        },
        opts = {
            pre_hook = function()
                require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            end,
        },
    },
    {
        'HiPhish/rainbow-delimiters.nvim',
    },
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
        'Wansmer/sibling-swap.nvim',
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
        keys = {
            {
                ']t',
                function()
                    require('todo-comments').jump_next()
                end,
                desc = 'Next todo comment',
            },
            {
                '[t',
                function()
                    require('todo-comments').jump_prev()
                end,
                desc = 'Previous todo comment',
            }
        }
    },
}
