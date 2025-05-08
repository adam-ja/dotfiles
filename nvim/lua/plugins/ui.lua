return {
    {
        'folke/tokyonight.nvim',
        lazy = false,
        priority = 1000, -- make sure this is loaded first
        opts = {
            styles = {
                comments = { italic = true },
                virtual_text = { italic = true },
            },
            on_highlights = function(highlights, colours)
                -- Highlight the current line blame virtual text as a comment (required to make it italic)
                highlights.GitSignsCurrentLineBlame = highlights.Comment
            end,
            dim_inactive = true,
        },
        config = function(_, opts)
            require('tokyonight').setup(opts)

            vim.cmd('colorscheme tokyonight-moon')
            vim.opt.cursorline = true
        end,
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
            'AndreM222/copilot-lualine',
            {
                'bezhermoso/todos-lualine.nvim',
                dependencides = {
                    'folke/todo-comments.nvim',
                },
            },
        },
        config = function()
            local todos_component = require('todos-lualine').component({
                -- Current file only
                cwd = '%',
            })

            require('lualine').setup({
                sections = {
                    lualine_a = {
                        {
                            'mode',
                            icon = '',
                        },
                    },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = {
                        {
                            'filename',
                            newfile_status = true,
                        },
                    },

                    lualine_x = {
                        {
                            todos_component,
                            cond = function()
                                local path = vim.fn.expand('%:p')
                                return vim.bo.buftype == '' and path ~= '' and vim.fn.filereadable(path)
                            end,
                        },
                        {
                            'diagnostics',
                            sources = { 'nvim_diagnostic' },
                            symbols = {
                                error = ' ',
                                warning = ' ',
                                info = ' ',
                                hint = ' ',
                                ok = ' '
                            },
                        },
                    },
                    lualine_y = {
                        {
                            'copilot',
                            show_colors = true,
                        },
                        'filetype',
                        {
                            'filesize',
                            icon = '',
                        },
                    },
                    lualine_z = {
                        {
                            function()
                                local search_term = vim.fn.getreg('/')

                                if vim.v.hlsearch == 0 or search_term == '' then
                                    return ''
                                end

                                local ok, result = pcall(vim.fn.searchcount)

                                if not ok or next(result) == nil then
                                    return ''
                                end

                                return string.format('%s [%d/%d]', search_term, result.current, result.total)
                            end,
                            icon = '',
                        },
                        {
                            '%c/%{strwidth(getline("."))}', -- column number
                            icon = '',
                        },
                        {
                            '%l/%L', -- line number
                            icon = '',
                        },
                    },
                },
                options = {
                    section_separators = {
                        left = '',
                        right = '',
                    },
                    component_separators = {
                        left = '',
                        right = '',
                    },
                },
            })
        end,
    },
    'edkolev/tmuxline.vim',
    {
        'luukvbaal/statuscol.nvim',
        opts = function()
            local builtin = require('statuscol.builtin')
            return {
                setopt = true,
                relculright = true,
                segments = {
                    { -- folds
                        text = {
                            builtin.foldfunc,
                            ' '
                        },
                        condition = {
                            true,             -- always show the output of foldfund
                            builtin.not_empty -- if the rest of the column isn't empty (i.e there are folds) add the separator
                        },
                        click = 'v:lua.ScFa',
                    },
                    { -- diagnostics
                        sign = {
                            namespace = { 'diagnostic' },
                            auto = true,
                            foldcolsed = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    { -- anything else
                        sign = {
                            name = { '.*' },
                            namespace = { '.*' },
                            text = { '.*' },
                            auto = true,
                        },
                    },
                    { -- line number
                        text = { builtin.lnumfunc },
                        click = 'v:lua.ScLa',
                    },
                    { -- gitsigns
                        sign = {
                            namespace = { 'gitsigns' },
                            foldclosed = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                },
            }
        end,
    },
    {
        'uga-rosa/ccc.nvim',
        config = function()
            local ccc = require('ccc')
            local pickers = require('ccc.config.default').pickers
            vim.list_extend(pickers, {
                ccc.picker.css_name,
                ccc.picker.defaults,
                ccc.picker.ansi_escape({
                    black = '#0c0c0c',
                    red = '#c50f1f',
                    green = '#13a10e',
                    yellow = '#c19c00',
                    blue = '#0037da',
                    magenta = '#881798',
                    cyan = '#3a96dd',
                    white = '#cccccc',
                    bright_black = '#767676',
                    bright_red = '#e74856',
                    bright_green = '#16c60c',
                    bright_yellow = '#f9f1a5',
                    bright_blue = '#3b78ff',
                    bright_magenta = '#b4009e',
                    bright_cyan = '#61d6d6',
                    bright_white = '#f2f2f2',
                }),
            })
            ccc.setup({
                highlight_mode = 'virtual',
                highlighter = {
                    auto_enable = true,
                },
                pickers = pickers
            })
        end,
    },
    {
        'declancm/cinnamon.nvim',
        opts = {
            keymaps = {
                basic = true,
                extra = true,
            },
            options = {
                delay = 1,
            },
        },
    },
    {
        'cpea2506/relative-toggle.nvim',
        event = 'BufEnter',
    },
    {
        'tzachar/highlight-undo.nvim',
        opts = {},
    },
    'Bekaboo/dropbar.nvim',
    {
        'folke/noice.nvim',
        event = 'VeryLazy',
        dependencies = {
            'MunifTanjim/nui.nvim',
            {
                'rcarriga/nvim-notify',
                opts = {
                    on_open = function(win)
                        vim.api.nvim_win_set_config(win, { focusable = false })
                    end,
                },
                keys = {
                    {
                        '<Leader>nd',
                        function()
                            require('notify').dismiss()
                        end,
                        desc = 'Dismiss all notification windows currently displayed',
                    },
                },
            },
        },
        init = function()
            vim.opt.shortmess:remove('t')
            vim.opt.shortmess:remove('T')
            vim.opt.shortmess:append('sW')
        end,
        opts = {
            lsp = {
                override = {
                    ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
                    ['vim.lsp.util.stylize_markdown'] = true,
                    ['cmp.entry.get_documentation'] = true,
                },
            },
            presets = {
                command_palette = true,
                lsp_doc_border = true,
            },
            views = {
                cmdline_popup = {
                    size = {
                        width = '75%',
                        height = 'auto',
                    },
                },
            },
            messages = {
                view_search = false,
            },
            routes = {
                -- https://github.com/folke/noice.nvim/wiki/Configuration-Recipes#ignore-certain-lsp-servers-for-progress-messages
                {
                    filter = {
                        event = 'lsp',
                        kind = 'progress',
                        cond = function(message)
                            local client = vim.tbl_get(message.opts, 'progress', 'client')
                            return client == 'null-ls'
                        end,
                    },
                    opts = { skip = true },
                },
            },
        },
        keys = {
            {
                '<C-d>',
                function()
                    -- If noice is showing lsp docs, scroll those, otherwise fallback to whatever else <C-d> does
                    if not require('noice.lsp').scroll(4) then
                        return '<C-d>'
                    end
                end,
                mode = { 'n', 'i', 's' },
                desc = 'Scroll down in LSP documentation',
                silent = true,
                expr = true,
            },
            {
                '<C-u>',
                function()
                    -- If noice is showing lsp docs, scroll those, otherwise fallback to whatever else <C-u> does
                    if not require('noice.lsp').scroll(-4) then
                        return '<C-u>'
                    end
                end,
                mode = { 'n', 'i', 's' },
                desc = 'Scroll up in LSP documentation',
                silent = true,
                expr = true,
            },
        },
    },
    {
        'yorickpeterse/nvim-pqf',
        opts = {},
    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            completions = { blink = { enabled = true } },
        },
    },
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        opts = {},
    },
}
