-- "Coding" related plugins that don't fit neatly into syntax, LSP, etc
return {
    {
        'vim-test/vim-test',
        keys = {
            {
                '<Leader>ta',
                '<cmd>TestSuite<CR>',
                desc = 'Run all tests',
            },
            {
                '<Leader>tf',
                '<cmd>TestFile<CR>',
                desc = 'Run all tests in current test file',
            },
            {
                '<Leader>tt',
                '<cmd>TestNearest<CR>',
                desc = 'Run single test closest to the cursor',
            },
            {
                '<Leader>tl',
                '<cmd>TestLast<CR>',
                desc = 'Re-run the last run test',
            },
            {
                '<Leader>tg',
                '<cmd>TestVisit<CR>',
                desc = 'Go to the last run test',
            },
        },
        config = function()
            -- Run tests with vim-test using the neovim terminal in a split window
            vim.g['test#strategy'] = 'neovim'
            -- Make it a vertical split
            vim.g['test#neovim#term_position'] = 'vertical'
        end,
    },
}
