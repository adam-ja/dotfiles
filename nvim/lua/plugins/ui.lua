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
                    cterm = 'bold',
                },
                htmlItalic = {
                    cterm = 'italic',
                },
                htmlLink = {
                    cterm = 'underline',
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
                        icon = '',
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
                    '%{coc#status()}',
                    {
                        'diagnostics',
                        sources = {'nvim_diagnostic', 'coc', 'ale'},
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
        opts = {
            setopt = true,
            separator = ' ',
        },
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
    {'nvim-tree/nvim-tree.lua',
        dependencies = {
            'nvim-tree/nvim-web-devicons',
        },
        opts = {
            view = {
                width = {
                    max = '40%',
                },
                number = true,
                relativenumber = true,
            },
        },
        keys = {
            {
                '<Leader>n',
                function ()
                    require('nvim-tree.api').tree.find_file({
                        open = true,
                        focus = true,
                    })
                end,
                desc = 'Open nvim-tree at the location of the current buffer',
            },
        },
    },
    'ap/vim-css-color',
    {'declancm/cinnamon.nvim',
        opts = {
            extra_keymaps = true,
            extended_keymaps = true,
            default_delay = 1,
        },
    },
    {'cpea2506/relative-toggle.nvim',
        event = 'BufEnter',
    },
}
