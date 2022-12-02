local M = {}

local function map_by_mode(mode, shortcut, command, options)
    options = options or {}

    if options['noremap'] == nil then
        options['noremap'] = true
    end

    if options['silent'] == nil then
        options['silent'] = true
    end

    vim.api.nvim_set_keymap(mode, shortcut, command, options)
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

return M
