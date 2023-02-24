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

return {
    {'neoclide/coc.nvim',
        branch = 'release',
        lazy = false,
        config = function ()
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
                'coc-spell-checker',
                'coc-tsserver',
                'coc-vetur',
                'coc-yaml',
                '@yaegassy/coc-intelephense'
            }

            -- Stop the cursor disappearing after running some coc commands
            vim.g.coc_disable_transparent_cursor = 1

            -- Highlight symbol under cursor on CursorHold
            vim.api.nvim_create_autocmd('CursorHold', {
                command = [[silent call CocActionAsync('highlight')]],
            })
        end,
        keys = {
            {
                '<CR>',
                [[coc#pum#visible() ? coc#pum#confirm() : "\<CR>"]],
                desc = 'Use return to apply the highlighted autocomplete option',
                expr = true,
                mode = 'i',
            },
            {
                '<Leader>d',
                [[<cmd>lua require('utils').close_floating_windows(); _G.coc_show_docs()<CR>]],
                desc = 'Show documentation in preview window',
            },
            {
                '<C-j>',
                [[coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"]],
                desc = 'Scroll floating window down',
                expr = true,
                nowait = true,
            },
            {
                '<C-k>',
                [[coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"]],
                desc = 'Scroll floating window up',
                expr = true,
                nowait = true,
            },
        },
    },
    {'phpactor/phpactor',
        build = 'composer install --no-dev -o',
        ft = 'php',
    },
}
