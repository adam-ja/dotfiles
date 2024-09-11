return {
    {'olimorris/onedarkpro.nvim',
        priority = 1000, -- make sure this is loaded first
        opts = {
            options = {
                cursorline = true,
            },
            styles = {
                comments = 'italic',
                virtual_text = 'italic',
            },
            highlights = {
                GitSignsCurrentLineBlame = {
                    -- Highlight the current line blame virtual text as a comment (required to make it italic)
                    link = 'Comment',
                },
                htmlBold = {
                    bold = true,
                },
                htmlItalic = {
                    italic = true,
                },
                htmlLink = {
                    underline = true,
                },
            },
        },
        config = function (_, opts)
            require('onedarkpro').setup(opts)

            vim.cmd('colorscheme onedark')
        end,
    },
    {'nvim-lualine/lualine.nvim',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            sections = {
                lualine_a = {
                    {
                        'mode',
                        icon = '',
                    },
                },
                lualine_b = {'branch', 'diff'},
                lualine_c = {
                    {
                        'filename',
                        newfile_status = true,
                    },
                },

                lualine_x = {
                    {
                        'diagnostics',
                        sources = {'nvim_diagnostic'},
                        symbols = {
                            error = '😡',
                            warn = '🤨',
                            info = '🙋',
                            hint = '💡',
                        },
                    },
                },
                lualine_y = {
                    'filetype',
                    {
                        'filesize',
                        icon = '',
                    },
                },
                lualine_z = {
                    {
                        function ()
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
                    left = '',
                    right = '',
                },
                component_separators = {
                    left = '',
                    right = '',
                },
            },
        },
    },
    'edkolev/tmuxline.vim',
    {'luukvbaal/statuscol.nvim',
        opts = function ()
            local builtin = require('statuscol.builtin')
            return {
                setopt = true,
                relculright = true,
                segments = {
                    {-- folds
                        text = {
                            builtin.foldfunc,
                            ' '
                        },
                        condition = {
                            true, -- always show the output of foldfund
                            builtin.not_empty -- if the rest of the column isn't empty (i.e there are folds) add the separator
                        },
                        click = 'v:lua.ScFa',
                    },
                    {-- diagnostics
                        sign = {
                            namespace = {'diagnostic/signs'},
                            auto = true,
                            foldcolsed = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                    {-- anything else
                        sign = {
                            name = {'.*'},
                            namespace = {'.*'},
                            text = {'.*'},
                            auto = true,
                        },
                    },
                    {-- line number
                        text = {builtin.lnumfunc},
                        click = 'v:lua.ScLa',
                    },
                    {-- gitsigns
                        sign = {
                            namespace = {'gitsigns'},
                            foldclosed = true,
                        },
                        click = 'v:lua.ScSa',
                    },
                },
            }
        end,
    },
    {'nathanaelkane/vim-indent-guides',
        init = function ()
            -- Enable indent guides by default
            vim.g.indent_guides_enable_on_vim_startup = 1
            -- Just use one character to highlight indent level rather than highlighting the full indent block
            vim.g.indent_guides_guide_size = 1
            -- Start indent guides from level 2 - no need to see it on column 1
            vim.g.indent_guides_start_level = 2
        end
    },
    {'NvChad/nvim-colorizer.lua',
        opts = {
            user_default_options = {
                css = true,
                tailwind = true,
                mode = 'background',
            },
        },
    },
    {'declancm/cinnamon.nvim',
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
    {'cpea2506/relative-toggle.nvim',
        event = 'BufEnter',
    },
    {'tzachar/highlight-undo.nvim',
        config = true,
    },
    'Bekaboo/dropbar.nvim',
    { 'rcarriga/nvim-notify',
        lazy = false,
        config = function ()
            vim.notify = require('notify')
        end,
    },
    {'yorickpeterse/nvim-pqf',
        config = true,
    },
}
