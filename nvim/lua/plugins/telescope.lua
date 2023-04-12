-- Note due to the dependencies and the way Telescope extensions are loaded, all key mappings for Telescope extensions
-- are defined in the main Telescope plugin configuration.
return {
    {'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
    },
    'nvim-telescope/telescope-ui-select.nvim',
    'fannheyward/telescope-coc.nvim',
    {'TENMAJKL/phpactor-telescope',
        dependencies = {
            'phpactor/phpactor',
        },
    },
    {'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-fzf-native.nvim',
            'nvim-telescope/telescope-ui-select.nvim',
            'fannheyward/telescope-coc.nvim',
            'TENMAJKL/phpactor-telescope',
        },
        branch = '0.1.x',
        lazy = false,
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = 'move_selection_previous',
                        ['<C-j>'] = 'move_selection_next',
                    },
                    n = {
                        ['<C-k>'] = 'move_selection_previous',
                        ['<C-j>'] = 'move_selection_next',
                    },
                },
                sorting_strategy = 'ascending',
                scroll_strategy = 'limit',
                prompt_prefix = ' 🔭 ',
                layout_config = {
                    prompt_position = 'top',
                    width = 0.95,
                    height = 0.95,
                    preview_width = 0.5,
                    scroll_speed = 5, -- number of lines to scroll through the previewer
                },
                dynamic_preview_title = true, -- use the picker result (e.g. file name) as the preview window title
                path_display = {'truncate'}, -- truncate the start of file paths if they are too long to display
                vimgrep_arguments = {
                    'rg',
                    '--vimgrep',
                    '--color=never',
                },
            },
            pickers = {
                buffers = {
                    ignore_current_buffer = true,
                    sort_mru = true,
                    mappings = {
                        i = {
                            ['<C-S-d>'] = 'delete_buffer',
                        },
                    },
                },
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('ui-select')
            require('telescope').load_extension('coc')

            vim.api.nvim_create_autocmd('User TelescopePreviewerLoaded', {
                command = 'setlocal wrap | setlocal number',
            })
        end,
        keys = {
            -- Find
            {
                '<Leader>ft',
                function()
                    require('telescope.builtin').builtin()
                end,
                desc = 'See all available Telescope pickers',
            },
            {
                '<Leader>ff',
                function()
                    require('telescope.builtin').find_files({hidden = true})
                end,
                desc = 'Find files in working directory',
            },
            {
                '<Leader>fg',
                function()
                    local builtin = require('telescope.builtin')
                    if not pcall(builtin.git_files, {show_untracked = true}) then
                        -- If not in a git repository, fall back to find_files
                        builtin.find_files({hidden = true})
                    end
                end,
                desc = 'Find git files in current repository (including untracked)',
            },
            {
                '<Leader>fm',
                function()
                    require('telescope.builtin').git_status()
                end,
                desc = 'Find modified files (according to git)',
            },
            {
                '<Leader>fb',
                function()
                    require('telescope.builtin').buffers()
                end,
                desc = 'Buffers',
            },
            {
                '<Leader>fl',
                function()
                    require('telescope.builtin').current_buffer_fuzzy_find()
                end,
                desc = 'Lines in the current buffer',
            },
            {
                '<Leader>fr',
                function()
                    require('telescope.builtin').live_grep()
                end,
                desc = 'Search within files in working directory',
            },
            {
                '<Leader>fR',
                function()
                    require('telescope.builtin').grep_string()
                end,
                desc = 'Search for the string under the cursor within files in working directory',
            },
            {
                '<Leader>fc',
                function()
                    require('telescope.builtin').git_bcommits()
                end,
                desc = 'Commits affecting current buffer',
            },
            {
                '<Leader>fC',
                function()
                    require('telescope.builtin').git_commits()
                end,
                desc = 'All commits',
            },

            -- LSP
            {
                '<Leader>ls',
                '<cmd>Telescope coc document_symbols<CR>',
                desc = 'LSP symbols (variables, methods, etc found by coc.nvim)',
            },
            {
                '<Leader>ld',
                '<cmd>Telescope coc definitions<CR>',
                desc = 'LSP definitions',
            },
            {
                '<Leader>lt',
                '<cmd>Telescope coc type_definitions<CR>',
                desc = 'LSP type definitions',
            },
            {
                '<Leader>li',
                '<cmd>Telescope coc implementations<CR>',
                desc = 'LSP implementations',
            },
            {
                '<Leader>lr',
                '<cmd>Telescope coc references<CR>',
                desc = 'LSP references',
            },
            {
                '<Leader>le',
                '<cmd>Telescope coc diagnostics<CR>',
                desc = 'LSP diagnostics in the buffer (e for errors)',
            },
            {
                '<Leader>la',
                '<cmd>Telescope coc code_actions<CR>',
                desc = 'LSP code actions for code under cursor',
            },
            {
                '<Leader>lla',
                '<cmd>Telescope coc line_code_actions<CR>',
                desc = 'LSP line-level code actions',
            },
            {
                '<Leader>lfa',
                '<cmd>Telescope coc file_code_actions<CR>',
                desc = 'LSP file-level code actions',
            },
            {
                '<Leader>p',
                '<cmd>PhpactorTelescope<CR>',
                desc = 'Open Phpactor in telescope',
            },
        },
    },
}
