return {
    {'williamboman/mason-lspconfig.nvim',
        lazy = false,
        dependencies = {
            {'williamboman/mason.nvim',
                config = true,
            },
            {'folke/neodev.nvim',
                config = true,
            },
        },
        build = ':MasonUpdate',
        config = function ()
            local mason_lspconfig = require('mason-lspconfig')

            mason_lspconfig.setup({
                ensure_installed = {
                    'bashls',
                    'cssls',
                    'dockerls',
                    'eslint',
                    -- TODO: change from emmet.vim to emmet-ls?
                    'html',
                    'jsonls',
                    'lua_ls',
                    'intelephense',
                    'tailwindcss',
                    'tsserver',
                    'vimls',
                    'yamlls',
                },
            })

            mason_lspconfig.setup_handlers({
                function (server_name)
                    require('lspconfig')[server_name].setup({})
                end
            })
        end,
    },
    {'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
        },
        keys = {
            {
                '<Leader>d',
                function ()
                    -- Prevent diagnostics from showing up when the hover window is open
                    -- https://www.reddit.com/r/neovim/comments/pg1o6k/neovim_lsp_hover_window_is_hidden_behind_line
                    vim.api.nvim_command('set eventignore=CursorHold')
                    vim.lsp.buf.hover()
                    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
                end,
                desc = 'Show documentation',
            },
            {
                '<Leader>la',
                vim.lsp.buf.code_action,
                desc = 'Show code actions',
            },
            {
                '<Leader>j',
                vim.diagnostic.goto_next,
                desc = 'Go to next diagnostic',
            },
            {
                '<Leader>k',
                vim.diagnostic.goto_prev,
                desc = 'Go to previous diagnostic',
            },
        },
        init = function ()
            vim.diagnostic.config({
                virtual_text = false,
                underline = false,
                severity_sort = true,
            })

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = 'rounded',
            })

            local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.api.nvim_create_autocmd("CursorHold", {
                callback = function()
                    vim.diagnostic.open_float({
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = 'if_many',
                        prefix = ' ',
                    })
                end
            })
        end
    },
    {'jose-elias-alvarez/null-ls.nvim',
        dependencies = {
            'williamboman/mason.nvim',
            'davidmh/cspell.nvim',
        },
        opts = function ()
            local builtins = require('null-ls').builtins
            local cspell = require('cspell')

            return {
                sources = {
                    -- PHP
                    builtins.diagnostics.phpstan,
                    -- builtins.formatting.phpcsfixer,
                    -- shell
                    builtins.hover.printenv,
                    -- spellcheck
                    cspell.code_actions,
                    cspell.diagnostics.with({
                        diagnostic_config = {
                            underline = true,
                            signs = false,
                        },
                    }),
                },
                -- Format on save
                on_attach = function(client, bufnr)
                    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
                    if client.supports_method('textDocument/formatting') then
                        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                        vim.api.nvim_create_autocmd('BufWritePre', {
                            group = augroup,
                            buffer = bufnr,
                            callback = function()
                                vim.lsp.buf.format({ bufnr = bufnr })
                            end,
                        })
                    end
                end,
            }
        end,
    },
    {'hrsh7th/nvim-cmp',
        dependencies = {
            'neovim/nvim-lspconfig',
            'onsails/lspkind.nvim',
            {'L3MON4D3/LuaSnip',
                build = 'make install_jsregexp',
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-nvim-lsp-signature-help',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-calc',
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                    }),
                },

                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },

                mapping = cmp.mapping.preset.insert({
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-j>'] = cmp.mapping.select_next_item(),
                    ['<C-k>'] = cmp.mapping.select_prev_item(),
                    ['<CR>'] = cmp.mapping.confirm({select = true}),
                    ['<C-q>'] = cmp.mapping.abort(),
                }),

                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'nvim_lsp_signature_help' },
                    { name = 'luasnip' },
                    {
                        name = 'buffer',
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end,
                        },
                    },
                    { name = 'path' },
                    { name = 'calc' },
                },

                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
            })

            cmp.setup.cmdline('/', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'buffer' },
                },
            })

            cmp.setup.cmdline(':', {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = 'path' },
                    { name = 'cmdline' },
                },
            })
        end,
    },
    {'phpactor/phpactor',
        build = 'composer install --no-dev -o',
        ft = 'php',
    },
    {'j-hui/fidget.nvim',
        config = true,
    }
}
