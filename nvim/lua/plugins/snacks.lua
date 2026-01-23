return { {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
        bigfile = { enabled = true },
        dashboard = { enabled = true },
        gitbrowse = { enabled = true },
        image = { enabled = true },
        indent = {
            enabled = true,
            scope = { enabled = false },
        },
    },
    keys = {
        {
            '<Leader>gg',
            function()
                require('snacks').gitbrowse.open()
            end,
            desc = 'Open the remote page of the current file in the browser (e.g. on GitHub)',
        },
    },
} }
