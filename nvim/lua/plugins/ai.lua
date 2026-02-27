---@type LazyPluginSpec[]
return {
    {
        'olimorris/codecompanion.nvim',
        version = '^18.6.0',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-treesitter/nvim-treesitter',
        },
        lazy = false,
        opts = {
            adapters = {
                acp = {
                    claude_code = function()
                        return require('codecompanion.adapters').extend('claude_code', {
                            defaults = {
                                model = 'opus',
                            },
                        })
                    end,
                },
                http = {
                    copilot_gemini = function()
                        return require('codecompanion.adapters').extend('copilot', {
                            schema = {
                                model = {
                                    default = 'gemini-2.5-pro',
                                }
                            }
                        })
                    end,
                }
            },
            interactions = {
                chat = { adapter = 'claude_code' },
                inline = { adapter = 'copilot_gemini' },
                cmd = { adapter = 'copilot_gemini' },
            },
        },
        keys = {
            {
                '<Leader>ca',
                '<cmd>CodeCompanionActions<CR>',
                desc = 'Open the CodeCompanion AI action palette',
            },
            {
                '<Leader>cc',
                ':CodeCompanionCmd ',
                desc = 'Begin a prompt for the CodeCompanion AI to create Neovim commands',
            },
            {
                '<Leader>ci',
                ':CodeCompanion ',
                desc = 'Begin a prompt for the CodeCompanion AI inline assistant',
            },
            {
                '<Leader>ct',
                '<cmd>CodeCompanionChat Toggle<CR>',
                desc = 'Toggle the CodeCompanion AI chat',
            },
        },
    },
}
