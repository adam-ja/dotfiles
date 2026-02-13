---@type LazyPluginSpec
return {
    ---@module 'snacks'
    'snacks.nvim',
    ---@type snacks.Config
    opts = {
        gitbrowse = { enabled = true },
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
}
