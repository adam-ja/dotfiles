return {
    {'williamboman/mason-lspconfig.nvim',
        lazy = false,
        dependencies = {
            {'williamboman/mason.nvim',
                config = true,
            },
            {'folke/lazydev.nvim',
                ft = 'lua',
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
                    'emmet_language_server',
                    'eslint',
                    'gopls',
                    'html',
                    'intelephense',
                    'jsonls',
                    'lua_ls',
                    -- 'tailwindcss', - TODO: this causes freezes when opening files that don't even have any CSS?!
                    'ts_ls',
                    -- 'typos_lsp', - TODO: Try to get this working to replace cspell
                    'vimls',
                    'yamlls',
                },
            })

            mason_lspconfig.setup_handlers({
                function (server_name)
                    require('lspconfig')[server_name].setup({})
                end,
                ['emmet_language_server'] = function ()
                    require('lspconfig').emmet_language_server.setup({
                        filetypes = {
                            'blade',
                            'css',
                            'html',
                            'javascript',
                            'javascriptreact',
                            'scss',
                            'typescript',
                            'typescriptreact',
                        },
                    })
                end,
                ['intelephense'] = function ()
                    require('lspconfig').intelephense.setup({
                        settings = {
                            intelephense = {
                                references = {
                                    -- Don't exclude the vendor directory from references search
                                    exclude = {}
                                }
                            }
                        }
                    })
                end,
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
                    require('utils').exclusive_float(vim.lsp.buf.hover)
                end,
                desc = 'Show documentation',
            },
            {
                '<Leader>la',
                vim.lsp.buf.code_action,
                desc = 'Show code actions',
                mode = {'n', 'v'},
            },
            {
                '<Leader>ln', -- n for name because r is used for references
                vim.lsp.buf.rename,
                desc = 'Rename the LSP symbol under the cursor'
            },
            {
                '<Leader>lD', -- ld for definition, lD for declaration
                vim.lsp.buf.declaration,
                desc = 'Go to declaration of the symbol under the cursor (e.g. interface or abstract method rather than concrete implementation)',
            },
            {
                '<Leader>j',
                function ()
                    vim.diagnostic.jump({count = 1, float = true})
                end,
                desc = 'Go to next diagnostic',
            },
            {
                '<Leader>k',
                function ()
                    vim.diagnostic.jump({count = -1, float = true})
                end,
                desc = 'Go to previous diagnostic',
            },
        },
        init = function ()
            vim.diagnostic.config({
                virtual_text = false,
                underline = false,
                severity_sort = true,
            })

            local severities = {
                Error = '',
                Warning = '',
                Info = '',
                Hint = '',
                Ok = ''
            }

            for name, icon in pairs(severities) do
                local hl = 'DiagnosticSign' .. name
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = 'rounded',
            })

            vim.api.nvim_create_autocmd("CursorHold", {
                callback = function()
                    vim.diagnostic.open_float({
                        focusable = false,
                        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                        border = 'rounded',
                        source = true,
                        prefix = ' ',
                    })
                end
            })
        end
    },
     -- Community maintained fork of null-ls - only the repo name has changed, the plugin is still called null-ls
    {'nvimtools/none-ls.nvim',
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
                    builtins.hover.dictionary,
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
                dependencies = {
                    'rafamadriz/friendly-snippets',
                },
            },
            'saadparwaiz1/cmp_luasnip',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'hrsh7th/cmp-calc',
        },
        config = function()
            local cmp = require('cmp')
            local lspkind = require('lspkind')
            local luasnip = require('luasnip')

            local has_words_before = function ()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1] :sub(col, col) :match('%s') == nil
            end

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

                    -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#luasnip
                    ['<Tab>'] = cmp.mapping(function (fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require('copilot.suggestion').is_visible() then
                            require('copilot.suggestion').accept()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, {'i', 's'}),

                    ['<S-Tab>'] = cmp.mapping(function (fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, {'i', 's'}),
                }),

                sources = {
                    { name = 'nvim_lsp' },
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
                    {
                        name = 'lazydev',
                        group_index = 0,
                    },
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

            cmp.event:on('menu_opened', function ()
                vim.b.copilot_suggestion_hidden = true
            end)

            cmp.event:on('menu_closed', function ()
                vim.b.copilot_suggestion_hidden = false
            end)

            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },
    {'phpactor/phpactor',
        build = 'composer install --no-dev -o',
        ft = 'php',
    },
}
