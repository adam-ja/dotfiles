-- Extensions to install
vim.g.coc_global_extensions = {
    'coc-blade',
    'coc-css',
    'coc-docker',
    'coc-highlight',
    'coc-html',
    'coc-json',
    'coc-lua',
    'coc-pairs',
    'coc-sh',
    'coc-tsserver',
    'coc-vetur',
    'coc-yaml',
    '@yaegassy/coc-intelephense'
}

-- Stop the cursor disappearing after running some coc commands
vim.g.coc_disable_transparent_cursor = 1

-- Highlight symbol under cursor on CursorHold (the conditional avoids errors if loading vim before the plugin is installed)
if vim.g.did_coc_loaded then
    vim.api.nvim_create_autocmd('CursorHold', {
        command = [[silent call CocActionAsync('highlight')]],
    })
end

-- Define where docs should come from
function _G.coc_show_docs()
    local cw = vim.fn.expand('<cword>')
    if vim.fn.index({ 'vim', 'help' }, vim.bo.filetype) >= 0 then
        vim.cmd('h ' .. cw)
    elseif vim.api.nvim_eval('coc#rpc#ready()') then
        vim.fn.CocActionAsync('doHover')
    else
        vim.cmd('!' .. vim.o.keywordprg .. ' ' .. cw)
    end
end

-- Key Mappings
---------------

local utils = require('utils')

-- Use return to apply the highlighted autocomplete option
utils.imap('<CR>', [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]], { expr = true })

-- Show documentation in preview window
utils.nmap('<Leader>d', '<CMD>lua _G.coc_show_docs()<CR>')

utils.nmap('<C-j>', [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"]], { expr = true, nowait = true })
utils.nmap('<C-k>', [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"]], { expr = true, nowait = true })

-- Go to definition with Ctrl-] maintained for muscle memory
utils.nmap('<C-]>', '<Plug>(coc-definition)')
utils.nmap('<Leader>cgd', '<Plug>(coc-definition)')
utils.nmap('<Leader>cgt', '<Plug>(coc-type-definition)')
utils.nmap('<Leader>cgi', '<Plug>(coc-implementation)')
utils.nmap('<Leader>cgr', '<Plug>(coc-references)')

-- Applying codeAction to the selected region.
-- Example: `<Leader>caap` for current paragraph
utils.xmap('<Leader>cas', '<Plug>(coc-codeaction-selected)')
utils.nmap('<Leader>cas', '<Plug>(coc-codeaction-selected)')

utils.nmap('<Leader>cal', '<Plug>(coc-codeaction-line)')

-- Remap keys for applying codeAction to the current buffer.
utils.nmap('<Leader>cba', '<Plug>(coc-codeaction)')

-- Run the Code Lens action on the current line.
utils.nmap('<Leader>cl', '<Plug>(coc-codelens-action)')
