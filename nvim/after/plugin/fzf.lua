-- Open fzf in full-screen mode
vim.g.fzf_layout = { down = '100%' }

-- Commands
-----------

-- Add a preview to the :Files command
vim.api.nvim_create_user_command(
    'Files',
    'call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)',
    { nargs = '?', complete = 'dir'}
)

-- Add a preview to the :Rg command
vim.api.nvim_create_user_command(
    'Rgfzf',
    [[call fzf#vim#grep('rg --column --no-heading --line-number --color=always ' . shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)]],
    { nargs = '*' }
)

-- Key Mappings
---------------

local utils = require('utils')

-- Lines in the current buffer
utils.nmap('<Leader>fl', ':BLines<CR>')
-- Files under working directory
utils.nmap('<Leader>ff', ':Files<CR>')
-- Open buffers
utils.nmap('<Leader>fb', ':Buffers<CR>')
-- Rg search within files under working directory (results open in fzf preview)
utils.nmap('<Leader>fr', ':Rgfzf<Space>', { silent = false })
-- Automatically submit search for word under cursor
utils.nmap('<Leader>fR', [[':Rgfzf<Space>' . expand('<cword>') . '<CR>']], { expr = true })
-- Modified files
utils.nmap('<Leader>fm', ':GFiles?<CR>')
-- Commits affecting current buffer
utils.nmap('<Leader>fc', ':BCommits<CR>')
-- All commits
utils.nmap('<Leader>fC', ':Commits<CR>')
-- Fuzzy search LSP symbols (variables, methods, etc found by coc.nvim)
utils.nmap('<Leader>fs', ':Vista finder coc<CR>')
