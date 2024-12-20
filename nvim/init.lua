-- Make <Space> the <Leader> key instead of the default \
-- lazy.nvim advises doing this at the top so that mappings are correct
vim.g.mapleader = ' '

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
    local output = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        'https://github.com/folke/lazy.nvim.git',
        '--branch=stable', -- latest stable release
        lazypath,
    })

    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { output,                         "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup(
-- Load plugins via the plugins module at ~/.config/nvim/lua/plugins
-- https://github.com/folke/lazy.nvim#-structuring-your-plugins
    'plugins',
    {
        checker = {
            update = true, -- automatically check for plugin updates
        },
    }
)


-- Indentation
--------------

-- Tabs = 4 spaces
vim.opt.tabstop = 4
-- Delete 4 spaces with backspace
vim.opt.softtabstop = 4
-- Use 4 spaces for (auto)indentation
vim.opt.shiftwidth = 4
-- Convert tabs to spaces
vim.opt.expandtab = true


-- Search
---------

-- Make search case-insensitive
vim.opt.ignorecase = true


-- Syntax
---------

-- Display whitespace
vim.opt.list = true
-- Highlight tabs and trailing spaces
vim.opt.listchars = { tab = '|·', trail = '`' }
-- Remove trailing spaces when saving a buffer, and return cursor to starting position
vim.api.nvim_create_autocmd('BufWritePre', {
    command = [[lua require('utils').preserve_cursor_position('%s/\\s\\+$//e')]]
})
-- Configure auto-formatting (see `:h fo-table`)
vim.opt.formatoptions:append('croqwanblj')
-- Consider lines that start with `- ` or `* ` as list characters for auto-formatting
vim.opt.formatlistpat:append([[\|^\s*[\*-]\s\+]])


-- Key mapping
--------------

local utils = require('utils')

-- Hide search highlighting
utils.nmap('<Leader>/', ':nohlsearch<CR>')
-- Disable arrow keys (except in insert mode) - use h,j,k,l
utils.map('<Up>', '<NOP>')
utils.map('<Down>', '<NOP>')
utils.map('<Left>', '<NOP>')
utils.map('<Right>', '<NOP>')
-- Easy window switching
utils.nmap('<C-h>', '<C-w>h')
utils.nmap('<C-j>', '<C-w>j')
utils.nmap('<C-k>', '<C-w>k')
utils.nmap('<C-l>', '<C-w>l')
-- Sort the paragraph around the current cursor position (above and below to the nearest blank line) alphabetically
utils.nmap('<Leader>al', '<C-v>apb:sort i<CR>')
-- Sort the selected lines alphabetically
utils.vmap('<Leader>al', ':sort<CR>')
-- Press Ctrl-q to get back to Normal mode from Terminal mode
utils.tmap('<C-q>', '<C-\\><C-n>')


-- Custom commands
------------------

-- Write/quit even if I accidentally hold down shift on :w/:q/:wq
vim.api.nvim_create_user_command('W', ':w<bang>', {})
vim.api.nvim_create_user_command('Q', ':q<bang>', {})
vim.api.nvim_create_user_command('WQ', ':wq<bang>', {})
vim.api.nvim_create_user_command('Wq', ':wq<bang>', {})

-- Delete current file and close the buffer
vim.api.nvim_create_user_command('Rm', ':call delete(expand("%")) | bwipeout!', {})


-- UI / styling
---------------

-- Update the terminal title to the filename
vim.opt.title = true
vim.opt.titlestring = 'nvim - %f'
-- Enable true colour
vim.opt.termguicolors = true
-- Show line numbers
vim.opt.number = true
-- Keep the cursor vertically centered, where possible
vim.opt.scrolloff = 999
-- Draw a vertical line at 120 characters
vim.opt.colorcolumn = '120'

-- Display folds in the status column (allows clickable folds with statuscol plugin)
vim.opt.foldcolumn = 'auto:3'
-- Limit nested folds to 3 levels deep (any more is unnecessary and makes the fold status column too wide)
vim.opt.foldnestmax = 3
-- Causes folds to be calculated but not collapsed when a buffer is opened (so they're displayed in foldcolumn)
vim.opt.foldlevelstart = 3
-- Modernise fold symbols
vim.opt.fillchars:append('foldopen:,foldsep:│,foldclose:')


-- Other
--------

-- Lower values allow plugins to respond quicker to changes, but can cause performance issues
vim.opt.updatetime = 300

-- Set persistent undo (so undo history is saved even when buffers are closed)
vim.opt.undofile = true

-- List all possible completions, completing to the longest common string first, and then each full match on subsequent
-- presses of <TAB>
vim.opt.wildmode = 'list:longest,full'

-- Use system clipboard by default
vim.opt.clipboard = 'unnamedplus'

-- Create missing parent directories when saving a file
vim.api.nvim_create_autocmd({ 'BufWritePre', 'FileWritePre' }, {
    callback = function(args)
        local dir = vim.fn.fnamemodify(args.file, ':p:h')

        if vim.fn.isdirectory(dir) == 0 then
            vim.fn.mkdir(dir, 'p')
        end
    end,
})
