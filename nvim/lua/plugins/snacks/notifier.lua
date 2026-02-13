---@type LazyPluginSpec
return {
    ---@module 'snacks'
    'snacks.nvim',
    ---@type snacks.Config
    opts = {
        notifier = { enabled = true },
    },
    keys = {
        {
            '<Leader>nd',
            function()
                require('snacks').notifier.hide()
            end,
            desc = 'Dismiss all notification windows currently displayed',
        },
    },
}
