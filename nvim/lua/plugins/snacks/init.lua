return {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    -- Simple snacks are configured in this file. Any with more complex config, keymaps, etc, are in their own files
    import = 'plugins.snacks',
    opts = {
        bigfile = { enabled = true },
        bufdelete = {
            enabled = true,
            wipe = true,
        },
        dashboard = { enabled = true },
        image = { enabled = true },
        indent = {
            enabled = true,
            scope = { enabled = false },
        },
        input = { enabled = true },
    },
}
