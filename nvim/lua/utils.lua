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

return M
