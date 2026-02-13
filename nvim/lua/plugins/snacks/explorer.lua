---@type LazyPluginSpec
return {
    ---@module 'snacks'
    'snacks.nvim',
    ---@type snacks.Config
    opts = {
        explorer = { enabled = true },
    },
    keys = {
        {
            '<Leader>F',
            function()
                require('snacks').explorer({
                    layout = {
                        preset = 'default',
                        preview = true,
                    },
                })
            end,
            desc = 'Open snacks file explorer',
        },
    },
}
