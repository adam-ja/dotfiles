return {
    {
        'mason-org/mason-lspconfig.nvim',
        lazy = false,
        dependencies = {
            {
                'mason-org/mason.nvim',
                opts = {},
            },
            {
                'folke/lazydev.nvim',
                ft = 'lua',
                cmd = "LazyDev",
                opts = {},
            },
        },
        build = ':MasonUpdate',
        config = function()
            require('mason-lspconfig').setup({
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
                    'rust_analyzer',
                    -- 'tailwindcss', - TODO: this causes freezes when opening files that don't even have any CSS?!
                    'ts_ls',
                    -- 'typos_lsp', - TODO: Try to get this working to replace cspell
                    'vimls',
                    'yamlls',
                },
                automatic_enable = {
                    exclude = {
                        -- Let rustaceanvim handle rust_analyzer
                        'rust_analyzer',
                    },
                },
            })
        end,
    },
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'mason-org/mason-lspconfig.nvim',
        },
        keys = {
            {
                '<Leader>d',
                function()
                    require('utils').exclusive_float(vim.lsp.buf.hover)
                end,
                desc = 'Show documentation',
            },
            {
                '<Leader>la',
                vim.lsp.buf.code_action,
                desc = 'Show code actions',
                mode = { 'n', 'v' },
            },
            {
                '<Leader>ln', -- n for name because r is used for references
                vim.lsp.buf.rename,
                desc = 'Rename the LSP symbol under the cursor'
            },
            {
                '<Leader>lD', -- ld for definition, lD for declaration
                vim.lsp.buf.declaration,
                desc =
                'Go to declaration of the symbol under the cursor (e.g. interface or abstract method rather than concrete implementation)',
            },
            {
                '<Leader>j',
                function()
                    vim.diagnostic.jump({ count = 1, float = true })
                end,
                desc = 'Go to next diagnostic',
            },
            {
                '<Leader>k',
                function()
                    vim.diagnostic.jump({ count = -1, float = true })
                end,
                desc = 'Go to previous diagnostic',
            },
            {
                '<Leader>lh',
                function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                end,
                desc = 'Toggle inlay hints',
            },
        },
        init = function()
            vim.diagnostic.config({
                virtual_text = false,
                underline = false,
                severity_sort = true,
                -- This is the correct way to configure diagnostic signs
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = '',
                        [vim.diagnostic.severity.WARN] = '',
                        [vim.diagnostic.severity.INFO] = '',
                        [vim.diagnostic.severity.HINT] = '',
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
                        [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
                        [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
                        [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
                    },
                },
            })

            -- Using `vim.fn.sign_define()` to configure diagnostic signs is deprecated in favour of the `signs` table
            -- in `vim.diagnostic.config()` but telescope.nvim still relies on it (`vim.fn.sign_getdefined(...)`
            -- https://github.com/nvim-telescope/telescope.nvim/blob/master/lua/telescope/make_entry.lua#L1151)
            for name, icon in pairs({
                Error = '',
                Warn = '',
                Info = '',
                Hint = '',
            }) do
                local hl = 'DiagnosticSign' .. name
                vim.fn.sign_define(hl, { text = icon, numhl = hl })
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

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)

                    if client:supports_method('textDocument/formatting') then
                        vim.api.nvim_create_autocmd("BufWritePre", {
                            buffer = args.buf,
                            callback = function()
                                vim.lsp.buf.format({
                                    async = false,
                                    bufnr = args.buf,
                                    id = client.id,
                                })
                            end,
                        })
                    end

                    if client:supports_method('textDocument/inlayHint') or client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
                    end
                end,
            })

            vim.lsp.config('emmet_language_server', {
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

            vim.lsp.config('intelephense', {
                settings = {
                    intelephense = {
                        codeLens = {
                            references = { enable = true },
                            implementations = { enable = true },
                            usages = { enable = true },
                            overrides = { enable = true },
                            parent = { enable = true },
                        },
                        format = {
                            -- Intelephense formatting rules aren't configurable - use PHP CS Fixer instead
                            enable = false,
                        },
                        references = {
                            -- Don't exclude the vendor directory from references search
                            exclude = {}
                        }
                    }
                }
            })

            vim.lsp.config('rust-analyzer', {
                cmd = function() -- `:h rustaceanvim.mason`
                    local mason_registry = require('mason-registry')

                    if (mason_registry.is_installed 'rust-analyzer') then
                        return { vim.fn.expand('$MASON/bin/rust-analyzer') }
                    else
                        -- global installation
                        return { 'rust-analyzer' }
                    end
                end,
                default_settings = {
                    ['rust-analyzer'] = {
                        cargo = {
                            targetDir = '/tmp/rust-analyzer-cargo',
                        },
                        lru = {
                            capacity = 64, -- number of syntax trees kept in memory (defaults to 128)
                        },
                    },
                },
            })
        end
    },
    -- Community maintained fork of null-ls - only the repo name has changed, the plugin is still called null-ls
    {
        'nvimtools/none-ls.nvim',
        dependencies = {
            'mason-org/mason.nvim',
            'davidmh/cspell.nvim',
        },
        opts = function()
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
            }
        end,
    },
    {
        'saghen/blink.cmp',
        version = '*',
        event = 'InsertEnter',
        dependencies = {
            {
                'onsails/lspkind.nvim',
                opts = {
                    symbol_map = {
                        Copilot = '',
                    }
                }
            },
            'xzbdmw/colorful-menu.nvim',
            {
                'fang2hou/blink-copilot',
                dependencies = {
                    {
                        'zbirenbaum/copilot.lua',
                        cmd = 'Copilot',
                        event = 'InsertEnter',
                        config = function()
                            require('copilot').setup({
                                panel = {
                                    enabled = false,
                                },
                                suggestion = {
                                    enabled = false,
                                },
                                filetypes = {
                                    ['*'] = true,
                                },
                            })
                        end
                    },
                },
            },
            {
                'L3MON4D3/LuaSnip',
                version = "v2.*",
                build = 'make install_jsregexp',
                dependencies = {
                    'rafamadriz/friendly-snippets',
                },
                config = function()
                    require('luasnip').setup()
                    require('luasnip.loaders.from_vscode').lazy_load()
                end,
            },
        },
        opts = {
            cmdline = {
                enabled = true,
                completion = {
                    menu = { auto_show = true },
                    list = { selection = { preselect = false, auto_insert = false } },
                },
                keymap = { preset = 'inherit' },
            },
            completion = {
                menu = {
                    border = 'rounded',
                    draw = {
                        columns = {
                            { 'kind_icon',  'kind', gap = 1 },
                            -- No need for label_description because colorful-menu.nvim merges it into label
                            { 'label' },
                            { 'source_name' },
                        },
                        components = {
                            -- https://cmp.saghen.dev/recipes.html#nvim-web-devicons-lspkind
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        local lspkind_icon = require("lspkind").symbolic(ctx.kind, {
                                            mode = "symbol",
                                        })
                                        if lspkind_icon then
                                            icon = lspkind_icon
                                        end
                                    end

                                    return icon .. ctx.icon_gap
                                end,
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },
                            kind = {
                                -- Same as kind_icon.highlight
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },
                            -- https://github.com/xzbdmw/colorful-menu.nvim#use-it-in-blinkcmp
                            label = {
                                text = function(ctx)
                                    return require("colorful-menu").blink_components_text(ctx)
                                end,
                                highlight = function(ctx)
                                    return require("colorful-menu").blink_components_highlight(ctx)
                                end,
                            },
                        },
                    },
                },
                documentation = {
                    window = { border = 'rounded' },
                    auto_show = true,
                    auto_show_delay_ms = 100,
                },
                ghost_text = { enabled = true },
                list = { selection = { preselect = false, auto_insert = false } },
                trigger = {
                    -- Default config blocks triggering on certain characters returned by sources (e.g. LSPs) but I
                    -- found this prevented completion when in places where I wanted it.
                    show_on_blocked_trigger_characters = {},
                    show_on_x_blocked_trigger_characters = {},
                },
            },
            keymap = {
                preset = 'none',
                ['<C-Space>'] = { 'show', 'fallback' },
                ['<Tab>'] = { 'snippet_forward', 'select_next', 'fallback' },
                ['<S-Tab>'] = { 'snippet_backward', 'select_prev', 'fallback' },
                ['<C-j>'] = { 'select_next', 'fallback' },
                ['<C-k>'] = { 'select_prev', 'fallback' },
                ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
                ['<C-q>'] = { 'cancel', 'fallback' },
                ['<CR>'] = { 'accept', 'fallback' },
            },
            signature = {
                enabled = true,
                window = { border = 'rounded' },
            },
            snippets = { preset = 'luasnip' },
            sources = {
                default = { 'copilot', 'lazydev', 'lsp', 'snippets', 'buffer', 'path', 'cmdline' },
                providers = {
                    -- https://cmp.saghen.dev/recipes.html#buffer-completion-from-all-open-buffers
                    buffer = {
                        opts = {
                            get_bufnrs = function()
                                return vim.tbl_filter(function(bufnr)
                                    return vim.bo[bufnr].buftype == ''
                                end, vim.api.nvim_list_bufs())
                            end
                        },
                    },
                    copilot = { name = 'copilot', module = 'blink-copilot', score_offset = 100, async = true },
                    lazydev = { name = 'lazydev', module = 'lazydev.integrations.blink', score_offset = 100 },
                },
            },
        },
        opts_extend = { 'sources.default' },
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        lazy = false,
    },
    {
        'Wansmer/symbol-usage.nvim',
        event = 'LspAttach',
        config = function()
            local SymbolKind = vim.lsp.protocol.SymbolKind

            local function h(name)
                return vim.api.nvim_get_hl(0, { name = name })
            end

            vim.api.nvim_set_hl(0, 'SymbolUsageRounding', { fg = h('CursorLine').bg, italic = true })
            vim.api.nvim_set_hl(0, 'SymbolUsageContent',
                { bg = h('CursorLine').bg, fg = h('CursorLine').fg, italic = true })

            require('symbol-usage').setup({
                kinds = {
                    SymbolKind.Class,
                    SymbolKind.Constant,
                    SymbolKind.Constructor,
                    SymbolKind.Enum,
                    SymbolKind.EnumMember,
                    SymbolKind.Function,
                    SymbolKind.Interface,
                    SymbolKind.Method,
                    SymbolKind.Property,
                    SymbolKind.Struct,
                },
                references = { enabled = true },
                definition = { enabled = true },
                implementation = { enabled = true },
                vt_position = 'end_of_line',
                request_pending_text = false,
                text_format = function(symbol)
                    local result = {}
                    local round_start = { '◖', 'SymbolUsageRounding' }
                    local round_end = { '◗', 'SymbolUsageRounding' }

                    -- Indicator shows if tere are any other symbols in the same line
                    local stacked_symbols_content = symbol.stacked_count > 0
                        and ('+%s'):format(symbol.stacked_count)
                        or ''

                    if symbol.references then
                        table.insert(result, round_start)
                        table.insert(result, {
                            ('%s %s'):format(symbol.references, symbol.references == 1 and 'usage' or 'usages'),
                            'SymbolUsageContent',
                        })
                        table.insert(result, round_end)
                    end

                    if symbol.definition then
                        if #result > 0 then
                            table.insert(result, { ' ', 'NonText' })
                        end
                        table.insert(result, round_start)
                        table.insert(result, {
                            ('%s %s'):format(symbol.definition, symbol.definition == 1 and 'definition' or 'definitions'),
                            'SymbolUsageContent',
                        })
                        table.insert(result, round_end)
                    end

                    if symbol.implementation then
                        if #result > 0 then
                            table.insert(result, { ' ', 'NonText' })
                        end
                        table.insert(result, round_start)
                        table.insert(result, {
                            ('%s %s'):format(symbol.implementation,
                                symbol.implementation == 1 and 'implementation' or 'implementations'),
                            'SymbolUsageContent',
                        })
                        table.insert(result, round_end)
                    end

                    if stacked_symbols_content ~= '' then
                        if #result > 0 then
                            table.insert(result, { ' ', 'NonText' })
                        end
                        table.insert(result, round_start)
                        table.insert(result, { stacked_symbols_content, 'SymbolUsageContent' })
                        table.insert(result, round_end)
                    end

                    return result
                end,
            })
        end,
    },
}
