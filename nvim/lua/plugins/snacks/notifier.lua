return {
    'snacks.nvim',
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
