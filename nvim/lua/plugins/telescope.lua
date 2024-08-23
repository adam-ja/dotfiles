-- Note due to the dependencies and the way Telescope extensions are loaded, all key mappings for Telescope extensions
-- are defined in the main Telescope plugin configuration.
return {
    {'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
            'nvim-telescope/telescope-ui-select.nvim',
            {'TENMAJKL/phpactor-telescope',
                dependencies = {
                    'phpactor/phpactor',
                },
            }
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

            vim.api.nvim_create_autocmd('User', {
                pattern = 'TelescopePreviewerLoaded',
                command = 'setlocal wrap | setlocal number',
            })
        end,
        keys = {
            {
                '<Leader>tr',
                function()
                    require('telescope.builtin').resume()
                end,
                desc = 'List the results (including multi-selections) of the last used telescope picker',
            },

            -- Find
            {
                '<Leader>ft',
                function()
                    require('telescope.builtin').builtin()
                end,
                desc = 'See all available Telescope pickers',
            },
            {
                '<Leader>fk',
                function()
                    require('telescope.builtin').keymaps()
                end,
                desc = 'Find key mappings',
            },
            {
                '<Leader>ff',
                function()
                    require('telescope.builtin').find_files({hidden = true, no_ignore = true})
                end,
                desc = 'Find files in working directory',
            },
            {
                '<Leader>fg',
                function()
                    local builtin = require('telescope.builtin')
                    if not pcall(builtin.git_files, {show_untracked = true}) then
                        -- If not in a git repository, fall back to find_files
                        builtin.find_files({hidden = true, no_ignore = true})
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
                '<Leader>frg',
                function()
                    require('telescope.builtin').live_grep()
                end,
                desc = 'Search within git files in working directory',
            },
            {
                '<Leader>frf',
                function()
                    require('telescope.builtin').live_grep({
                        additional_args = {'--no-ignore-vcs', '--hidden'},
                    })
                end,
                desc = 'Search within all files in working directory',
            },
            {
                '<Leader>frb',
                function()
                    require('telescope.builtin').live_grep({
                        additional_args = {'--no-ignore-vcs', '--hidden'},
                        grep_open_files = true,
                    })
                end,
                desc = 'Search within all open buffers',
            },
            {
                '<Leader>fRg',
                function()
                    require('telescope.builtin').grep_string()
                end,
                desc = 'Search for the string under the cursor within git files in working directory',
            },
            {
                '<Leader>fRg',
                function()
                    local selection = require('utils').get_selection()

                    if #selection > 1 then
                        vim.notify('Cannot search for multiline visual selection')

                        return
                    end

                    require('telescope.builtin').grep_string({
                        search = selection[1],
                        additional_args = {'--fixed-strings'},
                    })
                end,
                desc = 'Search for the selected string within git files in working directory',
                mode = 'v',
            },
            {
                '<Leader>fRf',
                function()
                    require('telescope.builtin').grep_string({
                        additional_args = {'--no-ignore-vcs', '--hidden'},
                    })
                end,
                desc = 'Search for the string under the cursor within all files in working directory',
            },
            {
                '<Leader>fRf',
                function()
                    local selection = require('utils').get_selection()

                    if #selection > 1 then
                        vim.notify('Cannot search for multiline visual selection')

                        return
                    end

                    require('telescope.builtin').grep_string({
                        search = selection[1],
                        additional_args = {'--fixed-strings', '--no-ignore-vcs', '--hidden'},
                    })
                end,
                desc = 'Search for the selected string within all files in working directory',
                mode = 'v',
            },
            {
                '<Leader>fRb',
                function()
                    require('telescope.builtin').grep_string({
                        additional_args = {'--no-ignore-vcs', '--hidden'},
                        grep_open_files = true,
                    })
                end,
                desc = 'Search for the string under the cursor within all open buffers',
            },
            {
                '<Leader>fRb',
                function()
                    local selection = require('utils').get_selection()

                    if #selection > 1 then
                        vim.notify('Cannot search for multiline visual selection')

                        return
                    end

                    require('telescope.builtin').grep_string({
                        search = selection[1],
                        additional_args = {'--fixed-strings', '--no-ignore-vcs', '--hidden'},
                        grep_open_files = true,
                    })
                end,
                desc = 'Search for the selected string within all open buffers',
                mode = 'v',
            },
            {
                '<Leader>fc',
                function()
                    require('telescope.builtin').git_bcommits({
                        wrap_results = true,
                        git_command = {
                            'git',
                            'log',
                            '--format=%h [%an, %ah] %s',
                            '--abbrev-commit',
                        },
                    })
                end,
                desc = 'Commits affecting current buffer',
            },
            {
                '<Leader>fC',
                function()
                    require('telescope.builtin').git_commits({
                        wrap_results = true,
                        git_command = {
                            'git',
                            'log',
                            '--format=%h [%an, %ah] %s',
                            '--abbrev-commit',
                            '--',
                            '.',
                        },
                    })
                end,
                desc = 'All commits',
            },
            {
                '<Leader>fn',
                function()
                    require('telescope').extensions.notify.notify()
                end,
                desc = 'Notification history'
            },

            -- LSP
            {
                '<Leader>ls',
                function()
                    require('telescope.builtin').lsp_document_symbols()
                end,
                desc = 'LSP symbols (variables, methods, etc)',
            },
            {
                '<Leader>ld',
                function()
                    require('telescope.builtin').lsp_definitions()
                end,
                desc = 'LSP definitions',
            },
            {
                '<Leader>lt',
                function()
                    require('telescope.builtin').lsp_type_definitions()
                end,
                desc = 'LSP type definitions',
            },
            {
                '<Leader>li',
                function()
                    require('telescope.builtin').lsp_implementations()
                end,
                desc = 'LSP implementations',
            },
            {
                '<Leader>lr',
                function()
                    require('telescope.builtin').lsp_references()
                end,
                desc = 'LSP references',
            },
            {
                '<Leader>le',
                function()
                    require('telescope.builtin').diagnostics({bufnr = 0})
                end,
                desc = 'LSP diagnostics in the buffer (e for errors)',
            },
            {
                '<Leader>lc',
                function ()
                    local pickers = require('telescope.pickers')
                    local finders = require('telescope.finders')
                    local conf = require('telescope.config').values

                    local commands = function()
                        local opts = {}
                        pickers.new(opts, {
                            prompt_title = 'LSP commands',
                            finder = finders.new_table(vim.lsp.commands),
                            sorter = conf.generic_sorter(opts),
                            attach_mappings = function(prompt_bufnr, map)
                                local execute = function()
                                    local selection = require('telescope.actions.state').get_selected_entry()
                                    require('telescope.actions').close(prompt_bufnr)
                                    vim.lsp.buf.execute_command(selection.value)
                                end

                                map('i', '<CR>', execute)
                                map('n', '<CR>', execute)

                                return true
                            end,
                        }):find()
                    end

                    commands()
                end,
                desc = 'Show LSP commands',
            },
            {
                '<Leader>p',
                '<cmd>PhpactorTelescope<CR>',
                desc = 'Open Phpactor in telescope',
            },
        },
    },
    {'axkirillov/easypick.nvim',
        dependencies = {
            'nvim-telescope/telescope.nvim',
        },
        config = function()
            local easypick = require('easypick')

            local pickers = {
                {
                    name = 'Conflicts',
                    command = 'git diff --name-only --diff-filter=U --relative',
                    previewer = easypick.previewers.file_diff(),
                },
                {
                    name = 'Changes in the last commit',
                    command = 'git diff --name-only HEAD~1..HEAD',
                    previewer = easypick.previewers.branch_diff({base_branch = 'HEAD~1'}),
                },
            }

            local branches = vim.fn.system("git branch -rl origin/develop origin/master origin/main --format '%(refname:short)'")

            for _, branch in ipairs(vim.fn.split(branches, '\n')) do
                table.insert(pickers, {
                    name = 'Changes between ' .. branch .. ' and the last commit',
                    command = 'git diff --name-only ' .. branch .. '..HEAD',
                    previewer = easypick.previewers.branch_diff({base_branch = branch}),
                })
            end

            easypick.setup({
                pickers = pickers,
            })
        end,
        keys = {
            {
                '<Leader>fe',
                '<cmd>Easypick<CR>',
                'Open the list of Easypick pickers in telescope'
            }
        }
    }
}
