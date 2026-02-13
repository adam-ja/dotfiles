---@type LazyPluginSpec
return {
    ---@module 'snacks'
    'snacks.nvim',
    ---@type snacks.Config
    opts = {
        rename = { enabled = true },
    },
    keys = {
        {
            '<Leader>lN',
            function()
                require('snacks').rename.rename_file()
            end,
            desc = 'Rename current file (triggers LSP handlers)',
        },
    },
}
