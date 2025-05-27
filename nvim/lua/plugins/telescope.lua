-- Enables opening multiple selected files at once
-- https://github.com/nvim-telescope/telescope.nvim/issues/1048
local multi_open = function(prompt_bufnr)
    local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
    local multi = picker:get_multi_selection()

    if vim.tbl_isempty(multi) then
        require('telescope.actions').select_default(prompt_bufnr)
        return
    end

    require('telescope.actions').close(prompt_bufnr)
    for _, entry in ipairs(multi) do
        local filename = entry.filename or entry.value
        if filename then
            local line = entry.lnum or 1
            local col = entry.col or 1
            vim.cmd(string.format('edit +%d %s', line, filename))
            vim.cmd(string.format('normal! %d|', col))
        end
    end
end

-- Note due to the dependencies and the way Telescope extensions are loaded, all key mappings for Telescope extensions
-- are defined in the main Telescope plugin configuration.
return {
    {
        'nvim-telescope/telescope.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
            'nvim-telescope/telescope-ui-select.nvim',
            {
                'TENMAJKL/phpactor-telescope',
                dependencies = {
                    'phpactor/phpactor',
                },
            },
            'adoyle-h/telescope-extension-maker.nvim',
            'nvim-telescope/telescope-file-browser.nvim',
            'nvim-telescope/telescope-symbols.nvim',
        },
        lazy = false,
        opts = {
            defaults = {
                mappings = {
                    i = {
                        ['<C-k>'] = 'move_selection_previous',
                        ['<C-j>'] = 'move_selection_next',
                        ['<CR>'] = multi_open,
                    },
                    n = {
                        ['<C-k>'] = 'move_selection_previous',
                        ['<C-j>'] = 'move_selection_next',
                        ['<CR>'] = multi_open,
                    },
                },
                wrap_results = true,
                sorting_strategy = 'ascending',
                scroll_strategy = 'limit',
                prompt_prefix = ' 🔭 ',
                layout_config = {
                    -- Shared between all layouts
                    prompt_position = 'top',
                    width = 0.95,
                    height = 0.95,
                    scroll_speed = 5, -- number of lines to scroll through the previewer

                    -- Layout specific
                    horizontal = {
                        preview_width = 0.5,
                    },
                    cursor = {
                        preview_width = 0.5,
                    },
                },
                dynamic_preview_title = true, -- use the picker result (e.g. file name) as the preview window title
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
                live_grep = {
                    additional_args = { '--hidden' },
                },
                grep_open_files = {
                    additional_args = { '--hidden' },
                },
            },
            extensions = {
                file_browser = {
                    hijack_netrw = true,
                    path = '%:p:h',
                    cwd_to_path = true,
                    select_buffer = true,
                    hidden = true,
                },
                ["ui-select"] = {
                    layout_strategy = 'cursor',
                    layout_config = {
                        width = 0.5,
                        height = 0.5,
                    },
                }
            },
        },
        config = function(_, opts)
            require('telescope').setup(opts)
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('ui-select')
            require('telescope').load_extension('file_browser')

            local maker = require('telescope-extension-maker')

            maker.register({
                name = 'lsp_commands',
                command = function()
                    return vim.tbl_keys(vim.lsp.commands)
                end,
                onSubmit = function(selection)
                    vim.lsp.buf.execute_command(selection)
                end,
                picker = {
                    prompt_title = 'LSP commands',
                },
            })

            vim.api.nvim_create_autocmd('User', {
                pattern = 'TelescopePreviewerLoaded',
                callback = function()
                    vim.wo.wrap = true
                    vim.wo.number = true
                end,
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
                '<Leader>F',
                function()
                    require('telescope').extensions.file_browser.file_browser()
                end,
                desc = 'Open telescope file browser',
            },
            {
                '<Leader>ft',
                function()
                    require('telescope.builtin').builtin({ include_extensions = true })
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
                    require('telescope.builtin').find_files({ hidden = true, no_ignore = true })
                end,
                desc = 'Find files in working directory',
            },
            {
                '<Leader>fg',
                function()
                    local builtin = require('telescope.builtin')
                    if not pcall(builtin.git_files, { show_untracked = true }) then
                        -- If not in a git repository, fall back to find_files
                        builtin.find_files({ hidden = true, no_ignore = true })
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
                        additional_args = { '--no-ignore-vcs' },
                    })
                end,
                desc = 'Search within all files in working directory',
            },
            {
                '<Leader>frb',
                function()
                    require('telescope.builtin').live_grep({
                        additional_args = { '--no-ignore-vcs' },
                        grep_open_files = true,
                    })
                end,
                desc = 'Search within all open buffers',
            },
            {
                '<Leader>frm',
                function()
                    -- Relies on git-extras being installed for git delta
                    local files = vim.fn.split(vim.fn.system('git delta ' .. require('utils').git_main_branch()), '\n')

                    require('telescope.builtin').live_grep({
                        prompt_title = 'Search within files that differ from the main branch',
                        search_dirs = files,
                    })
                end,
                desc = 'Search within files that differ from the main branch'
            },
            {
                '<Leader>frM',
                function()
                    -- Relies on git-extras being installed for git delta
                    local files = vim.fn.split(vim.fn.system('git delta ' .. require('utils').git_develop_branch()), '\n')

                    require('telescope.builtin').live_grep({
                        prompt_title = 'Search within files that differ from the develop branch',
                        search_dirs = files,
                    })
                end,
                desc = 'Search within files that differ from the develop branch'
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
                        additional_args = { '--fixed-strings' },
                    })
                end,
                desc = 'Search for the selected string within git files in working directory',
                mode = 'v',
            },
            {
                '<Leader>fRf',
                function()
                    require('telescope.builtin').grep_string({
                        additional_args = { '--no-ignore-vcs' },
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
                        additional_args = { '--fixed-strings', '--no-ignore-vcs' },
                    })
                end,
                desc = 'Search for the selected string within all files in working directory',
                mode = 'v',
            },
            {
                '<Leader>fRb',
                function()
                    require('telescope.builtin').grep_string({
                        additional_args = { '--no-ignore-vcs' },
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
                        additional_args = { '--fixed-strings', '--no-ignore-vcs' },
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
            {
                '<Leader>fq',
                function()
                    require('telescope.builtin').quickfix()
                end,
                desc = 'Quickfix list items',
            },
            {
                '<Leader>fQ',
                function()
                    require('telescope.builtin').quickfixhistory()
                end,
                desc = 'Quickfix list history',
            },
            {
                '<Leader>fi',
                function()
                    require('telescope.builtin').symbols()
                end,
                desc = 'Pick an icon/symbol',
            },
            {
                '<A-i>',
                function()
                    require('telescope.builtin').symbols()
                end,
                desc = 'Pick an icon/symbol',
                mode = 'i',
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
                    require('telescope.builtin').diagnostics({ bufnr = 0 })
                end,
                desc = 'LSP diagnostics in the buffer (e for errors)',
            },
            {
                '<Leader>fd',
                function()
                    require('telescope.builtin').diagnostics()
                end,
                desc = 'LSP diagnostics for the current workspace',
            },
            {
                '<Leader>lc',
                function()
                    require('telescope').extensions.lsp_commands.lsp_commands()
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
    {
        'axkirillov/easypick.nvim',
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
                    previewer = easypick.previewers.branch_diff({ base_branch = 'HEAD~1' }),
                },
            }

            local main_branch = require('utils').git_main_branch()
            local develop_branch = require('utils').git_develop_branch()

            for _, branch in ipairs({ main_branch, develop_branch }) do
                table.insert(pickers, {
                    name = 'Changes between ' .. branch .. ' and the last commit',
                    command = 'git diff --name-only ' .. branch .. '..HEAD',
                    previewer = easypick.previewers.branch_diff({ base_branch = branch }),
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
                desc = 'Open the list of Easypick pickers in telescope',
            }
        }
    }
}
