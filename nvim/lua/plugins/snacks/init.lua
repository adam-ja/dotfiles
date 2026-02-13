---@type LazyPluginSpec
return {
    ---@module 'snacks'
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    -- Simple snacks are configured in this file. Any with more complex config, keymaps, etc, are in their own files
    import = 'plugins.snacks',
    ---@type snacks.Config
    opts = {
        bigfile = { enabled = true },
        bufdelete = {
            enabled = true,
            wipe = true,
        },
        image = { enabled = true },
        indent = {
            enabled = true,
            scope = { enabled = false },
        },
        input = { enabled = true },
    },
}
