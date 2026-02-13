---@param ctx snacks.picker.preview.ctx
local file_with_path_previewer = function(ctx)
    -- Use the default file previewer
    require('snacks').picker.preview.file(ctx)
    -- Then update the title to show the file path (relative to the CWD) rather than just the name
    ctx.preview:set_title(vim.fn.fnamemodify(ctx.item.file, ':.'))
end

---@param item snacks.picker.finder.Item
---@return boolean
local reject_codebook_diagnostics_filter = function(item)
    local reject_namespace = require('utils').get_diagnostic_namespace('codebook')

    return item.item.namespace ~= reject_namespace
end

---@type snacks.picker.win.Config
local uncommitted_changes_keys = {
    input = {
        keys = {
            ['<Tab>'] = { 'select_and_next', mode = { 'i', 'n' } },
            ['<C-s>'] = { 'git_stage', mode = { 'i', 'n' } },
        },
    },
}

---@type LazyPluginSpec
return {
    'snacks.nvim',
    ---@type snacks.Config
    opts = {
        picker = {
            enabled = true,
            prompt = '⛏️ ',
            layout = {
                fullscreen = true,
            },
            layouts = {
                select = { layout = { relative = 'cursor' } },
            },
            sources = {
                buffers = {
                    current = false,
                    preview = file_with_path_previewer,
                },
                diagnostics = { preview = file_with_path_previewer },
                files = { preview = file_with_path_previewer },
                git_files = { preview = file_with_path_previewer },
                grep = { preview = file_with_path_previewer },
                grep_buffers = { preview = file_with_path_previewer },
                grep_word = { preview = file_with_path_previewer },
                lsp_definitions = { preview = file_with_path_previewer },
                lsp_implementations = { preview = file_with_path_previewer },
                lsp_references = { preview = file_with_path_previewer },
                lsp_type_definitions = { preview = file_with_path_previewer },
            },
            -- Replace `vim.ui.select` with the snacks picker
            ui_select = true,
            win = {
                input = {
                    keys = {
                        ['<C-d>'] = { 'preview_scroll_down', mode = { 'n', 'i' } },
                        ['<C-u>'] = { 'preview_scroll_up', mode = { 'n', 'i' } },
                    },
                },
            },
        },
    },
    keys = {
        -- Find stuff
        {
            '<Leader>fb',
            function()
                require('snacks').picker.buffers({
                    ---@type snacks.picker.win.Config
                    win = {
                        input = {
                            keys = {
                                ['<C-S-d>'] = { 'bufdelete', mode = { 'n', 'i' } },
                            },
                        },
                    },
                })
            end,
            desc = 'Find open buffers',
        },
        {
            '<Leader>fB',
            function()
                require('snacks').picker.buffers({
                    title = 'Modified Buffers',
                    modified = true,
                })
            end,
            desc = 'Find modified/unsaved open buffers',
        },
        {
            '<Leader>fd',
            function()
                require('snacks').picker.diagnostics_buffer({
                    -- Exclude spelling mistakes
                    filter = { filter = reject_codebook_diagnostics_filter },
                })
            end,
            desc = 'LSP diagnostics in the current buffer',
        },
        {
            '<Leader>fD',
            function()
                require('snacks').picker.diagnostics({
                    -- Exclude spelling mistakes
                    filter = { filter = reject_codebook_diagnostics_filter },
                })
            end,
            desc = 'LSP diagnostics for the current workspace',
        },
        {
            '<Leader>ff',
            function()
                require('snacks').picker.files({
                    hidden = true,
                    ignored = true,
                })
            end,
            desc = 'Find files in working directory',
        },
        {
            '<Leader>fg',
            function()
                require('snacks').picker.git_files({
                    untracked = true,
                })
            end,
            desc = 'Find git files in current repository (including untracked)',
        },
        {
            '<Leader>fi',
            function()
                require('snacks').picker.icons()
            end,
            desc = 'Pick an icon/symbol',
        },
        {
            '<A-i>',
            function()
                require('snacks').picker.icons()
            end,
            desc = 'Pick an icon/symbol',
            mode = 'i',
        },
        {
            '<Leader>fk',
            function()
                require('snacks').picker.keymaps()
            end,
            desc = 'Find keymaps',
        },
        {
            '<Leader>fl',
            function()
                require('snacks').picker.lines()
            end,
            desc = 'Search lines in the current buffer',
        },
        {
            '<Leader>fn',
            function()
                require('snacks').picker.notifications()
            end,
            desc = 'Notification history',
        },
        {
            '<Leader>fpp',
            function()
                require('snacks').picker.pickers()
            end,
            desc = 'List available snacks pickers',
        },
        {
            '<Leader>fpr',
            function()
                require('snacks').picker.resume()
            end,
            desc = 'Resume last used picker',
        },
        {
            '<Leader>frb',
            function()
                require('snacks').picker.grep_buffers({
                    hidden = true,
                    ignored = true,
                    need_search = true,
                })
            end,
            desc = 'Search within all open buffers',
        },
        {
            '<Leader>fRb',
            function()
                require('snacks').picker.grep_word({
                    title = 'Grep Buffers',
                    buffers = true,
                    hidden = true,
                    ignored = true,
                })
            end,
            desc = 'Search for the current word or selection within all open buffers',
            mode = { 'n', 'v' },
        },
        {
            '<Leader>frf',
            function()
                require('snacks').picker.grep({
                    title = 'Grep Files',
                    hidden = true,
                    ignored = true,
                })
            end,
            desc = 'Search within all files in the working directory',
        },
        {
            '<Leader>fRf',
            function()
                require('snacks').picker.grep_word({
                    title = 'Grep Files',
                    hidden = true,
                    ignored = true,
                })
            end,
            desc = 'Search for the current word or selection within all files in the working directory',
            mode = { 'n', 'v' },
        },
        {
            '<Leader>frg',
            function()
                require('snacks').picker.grep({
                    title = 'Grep Git Files',
                })
            end,
            desc = 'Search within the git repository',
        },
        {
            '<Leader>fRg',
            function()
                require('snacks').picker.grep_word({
                    title = 'Grep Git Files',
                })
            end,
            desc = 'Search for the current word or selection within the git repository',
            mode = { 'n', 'v' },
        },
        {
            '<Leader>fs',
            function()
                local namespace = require('utils').get_diagnostic_namespace('codebook')

                require('snacks').picker.diagnostics_buffer({
                    title = 'Spelling Mistakes',
                    filter = {
                        filter = function(item)
                            return item.item.namespace == namespace
                        end
                    },
                })
            end,
            desc = 'Spelling mistakes in the current buffer',
        },
        {
            '<Leader>ft',
            function()
                require('snacks').picker.todo_comments({
                    keywords = { 'TODO', 'FIX', 'FIXME' },
                })
            end,
            desc = 'Find todo comments',
        },
        {
            '<Leader>fu',
            function()
                require('snacks').picker.undo()
            end,
            desc = 'Undo history',
        },

        -- Git
        {
            '<Leader>gc',
            function()
                require('snacks').picker.git_status({
                    title = 'Git Conflicts',
                    transform = function(item)
                        if not item.text:match('^[UAD][UAD]%s') then
                            return false
                        end
                    end
                })
            end,
            desc = 'Git conflicts'
        },
        {
            '<Leader>gdd',
            function()
                require('snacks').picker.git_diff({
                    title = 'Dev Branch Diff',
                    group = true,
                    cmd_args = { string.format('%s..HEAD', require('utils').git_develop_branch()) },
                })
            end,
            desc = 'Show changes between the develop branch and the last commit [git]',
        },
        {
            '<Leader>gdl',
            function()
                require('snacks').picker.git_diff({
                    title = 'Last Commit Diff',
                    group = true,
                    cmd_args = { 'HEAD~1..HEAD' },
                })
            end,
            desc = 'Show the last commit [git]',
        },
        {
            '<Leader>gdm',
            function()
                require('snacks').picker.git_diff({
                    title = 'Main Branch Diff',
                    group = true,
                    cmd_args = { string.format('%s..HEAD', require('utils').git_main_branch()) },
                })
            end,
            desc = 'Show changes between the main branch and the last commit [git]',
        },
        {
            '<Leader>gdu',
            function()
                require('snacks').picker.git_status({
                    win = uncommitted_changes_keys,
                })
            end,
            desc = 'Show files with uncommitted changes (one result per file) [git]',
        },
        {
            '<Leader>gdU',
            function()
                require('snacks').picker.git_diff({
                    win = uncommitted_changes_keys,
                })
            end,
            desc = 'Show uncommitted changes (one result per hunk) [git]',
        },
        {
            '<Leader>gla',
            function()
                require('snacks').picker.git_log({
                    title = 'Git Log'
                })
            end,
            desc = 'Git commit history for the current repository',
        },
        {
            '<Leader>glf',
            function()
                require('snacks').picker.git_log_file({
                    title = 'Git Log - Current File'
                })
            end,
            desc = 'Git commit history for the current file',
        },
        {
            '<Leader>gll',
            function()
                require('snacks').picker.git_log_line({
                    title = 'Git Log - Current Line'
                })
            end,
            desc = 'Git commit history for the current line',
        },

        -- LSP
        {
            '<Leader>ld',
            function()
                require('snacks').picker.lsp_definitions()
            end,
            desc = 'LSP definitions',
        },
        {
            '<Leader>li',
            function()
                require('snacks').picker.lsp_implementations()
            end,
            desc = 'LSP implementations',
        },
        {
            '<Leader>lr',
            function()
                require('snacks').picker.lsp_references()
            end,
            desc = 'LSP references',
        },
        {
            '<Leader>ls',
            function()
                require('snacks').picker.lsp_symbols()
            end,
            desc = 'LSP symbols (variables, methods, etc) in the current buffer',
        },
        {
            '<Leader>lt',
            function()
                require('snacks').picker.lsp_type_definitions()
            end,
            desc = 'LSP type definitions',
        },
    },
}
