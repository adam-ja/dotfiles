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
                    'emmet_language_server',
                    'eslint',
                    'gopls',
                    'html',
                    'intelephense',
                    'jsonls',
                    'lua_ls',
                    -- 'tailwindcss', - TODO: this causes freezes when opening files that don't even have any CSS?!
                    'tsserver',
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
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '😡',
                        [vim.diagnostic.severity.WARN] = '🤨',
                        [vim.diagnostic.severity.INFO] = '🙋',
                        [vim.diagnostic.severity.HINT] = '💡',
                    },
                }
            })

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
            'hrsh7th/cmp-nvim-lsp-signature-help',
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
    {'j-hui/fidget.nvim',
        config = true,
    }
}
