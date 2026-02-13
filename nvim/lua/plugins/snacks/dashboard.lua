---@type LazyPluginSpec
return {
    ---@module 'snacks'
    'snacks.nvim',
    ---@type snacks.Config
    opts = {
        dashboard = {
            enabled = true,
            preset = {
                keys = {
                    {
                        icon = '',
                        key = 'n',
                        desc = 'New File',
                        action = ':enew',
                    },
                    {
                        icon = '',
                        key = 's',
                        desc = 'Restore Session',
                        section = 'session',
                    },
                    {
                        icon = '󰒲',
                        key = 'L',
                        desc = 'Lazy',
                        action = ':Lazy',
                        enabled = package.loaded.lazy ~= nil,
                    },
                    {
                        icon = '',
                        key = 'c',
                        desc = 'Config',
                        action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})"
                    },
                    {
                        icon = '󰩈',
                        key = 'q',
                        desc = 'Quit',
                        action = ':qa',
                    },
                },
                header = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣴⣶⣶⣾⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⣿⠿⠿⠛⣻⣿⣿⣿⣿⣿⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣠⣾⣿⡿⠛⠉⠀⠀⠀⣰⣿⣿⣿⠟⣿⣿⣿⣿⢿⣿⣷⣦⠀⠀⠀⠀
⠀⠀⢠⣾⣿⡟⠁⠀⠀⠀⠀⠀⣰⣿⣿⣿⡟⠀⣿⣿⣿⣿⠀⠈⢻⣿⣷⡄⠀⠀
⠀⢠⣿⣿⠏⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⡟⠀⠀⣿⣿⣿⣿⠀⠀⠀⠹⣿⣿⡄⠀
⢀⣿⣿⠏⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⡿⠁⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠸⣿⣿⡄
⣸⣿⡟⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⠃⠀⠀⠀⣿⣿⣿⣿⠀⠀⠀⠀⠀⢻⣿⣇
⣿⣿⡇⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⠇⠀⠀⠀⠀⣈⠻⣿⣿⠀⠀⠀⠀⠀⢸⣿⣿
⣿⣿⡇⠀⠀⠀⠀⢠⣿⣿⣿⣿⣯⣤⣤⣤⣤⣤⣿⣶⣌⠻⠀⠀⠀⠀⠀⢸⣿⣿
⢻⣿⣇⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⣸⣿⡟
⠘⣿⣿⡄⠀⢠⣿⣿⣿⣿⡿⠿⠿⠿⠿⠿⠿⢿⣿⣿⠟⢋⠀⠀⠀⠀⢠⣿⣿⠃
⠀⠹⣿⡿⢀⣿⣿⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠸⠋⣡⣴⣿⠀⠀⠀⣠⣿⣿⠏⠀
⠀⠀⠙⢁⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠚⠛⠛⠛⠀⢀⣴⣿⣿⠋⠀⠀
⠀⠀⢀⣾⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣴⣿⣿⠟⠁⠀⠀⠀
⠀⢀⣾⣿⣿⣿⣿⠏⣰⣿⣶⣦⣤⣤⣤⣤⣤⣤⣴⣶⣿⣿⡿⠛⠁⠀⠀⠀⠀⠀
⢀⣾⣿⣿⣿⣿⡟⠀⠈⠙⠛⠻⠿⠿⠿⠿⠿⠿⠟⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀]],
            },
        },
    },
}
