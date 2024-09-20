local M = {}

local function map_by_mode(mode, shortcut, command, options)
    options = options or {}

    if options['noremap'] == nil then
        options['noremap'] = true
    end

    if options['silent'] == nil then
        options['silent'] = true
    end

    vim.keymap.set(mode, shortcut, command, options)
end

-- Map in all modes except insert
function M.map(shortcut, command, options)
    map_by_mode('', shortcut, command, options)
end

-- Map in normal mode
function M.nmap(shortcut, command, options)
    map_by_mode('n', shortcut, command, options)
end

-- Map in visual and select mode
function M.vmap(shortcut, command, options)
    map_by_mode('v', shortcut, command, options)
end

-- Map in visual mode
function M.xmap(shortcut, command, options)
    map_by_mode('x', shortcut, command, options)
end

-- Map in terminal mode
function M.tmap(shortcut, command, options)
    map_by_mode('t', shortcut, command, options)
end

-- Map in insert mode
function M.imap(shortcut, command, options)
    map_by_mode('i', shortcut, command, options)
end

-- Execute a command but maintain original cursor position
-- https://stackoverflow.com/a/70730552
function M.preserve_cursor_position(command)
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    vim.api.nvim_command(string.format('keepjumps keeppatterns execute %q', command))
    -- If the command has shortened the file and the cursor was previously on the last line, it will need to move up to
    -- the new last line.
    local last_line = vim.fn.line("$")
    if line > last_line then
        line = last_line
    end
    vim.api.nvim_win_set_cursor(0, { line, col })
end


-- Open a floating window (triggered by the show_float function) without any other floating windows open
function M.exclusive_float(show_float)
    assert(type(show_float) == 'function', 'show_float must be a function')

    -- Prevent diagnostics from being displayed when hovering on a line with LSP diagnostic issues
    -- https://www.reddit.com/r/neovim/comments/pg1o6k/neovim_lsp_hover_window_is_hidden_behind_line
    vim.api.nvim_command('set eventignore=CursorHold')

    -- Close any existing floating windows
    -- https://www.reddit.com/r/neovim/comments/nrz9hp/comment/h0lg5m1
    for _, window_id in ipairs(vim.api.nvim_list_wins()) do
        local config = vim.api.nvim_win_get_config(window_id)
        if config.relative ~= '' then
            vim.api.nvim_win_close(window_id, false)
        end
    end

    show_float()

    -- Re-enable diagnostics display
    vim.api.nvim_command('autocmd CursorMoved <buffer> ++once set eventignore=""')
end

-- Get the current selection in visual mode
function M.get_selection()
    return vim.fn.getregion(
        vim.fn.getpos('v'),
        vim.fn.getpos('.'),
        { type = vim.fn.mode() }
    )
end

-- Get the name of the main branch for the current git repository
function M.git_main_branch()
    return vim.fn.split(
        vim.fn.system("git branch -rl origin/master origin/main --format '%(refname:short)'"),
        '\n'
    )[1]
end

-- Get the name of the develop branch for the current git repository
function M.git_develop_branch()
    return vim.fn.split(
        vim.fn.system("git branch -rl origin/develop origin/dev origin/development --format '%(refname:short)'"),
        '\n'
    )[1]
end

return M
