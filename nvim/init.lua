-- Disable netrw straight away (advised by nvim-tree)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

--------------
-- VIM-PLUG --
--------------
local plug_path = vim.fn.stdpath('data') .. '/site/autoload/plug.vim'
if vim.fn.empty(vim.fn.glob(plug_path)) > 0 then
    vim.fn.system {
        'curl',
        '-fLo',
        plug_path,
        '--create-dirs',
        'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    }
    vim.api.nvim_create_autocmd('VimEnter', {
        command = 'PlugInstall --sync',
    })
    vim.cmd('source ' .. os.getenv('MYVIMRC'))
end

-- https://dev.to/vonheikemen/neovim-using-vim-plug-in-lua-3oom

local Plug = vim.fn['plug#']

-- Initialise vim-plug to install plugins
vim.call('plug#begin', '~/.config/nvim/plugged')

-- Libraries
------------
Plug('nvim-lua/plenary.nvim')

-- Telescope
---------------
Plug('nvim-telescope/telescope.nvim', {branch = '0.1.x'})
Plug('nvim-telescope/telescope-fzf-native.nvim', {['do'] = 'make'})
Plug 'nvim-telescope/telescope-ui-select.nvim'
Plug 'fannheyward/telescope-coc.nvim'
Plug 'TENMAJKL/phpactor-telescope'

-- Syntax
---------
Plug 'dense-analysis/ale'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.cmd['TSUpdate']})
Plug('neoclide/coc.nvim', {branch = 'release'})
Plug('iamcco/markdown-preview.nvim', {['do'] = vim.fn['mkdp#util#install']})
Plug 'p00f/nvim-ts-rainbow'
Plug 'gpanders/editorconfig.nvim'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'
Plug 'numToStr/Comment.nvim'

-- Utilities
------------
Plug 'vim-scripts/SearchComplete'
Plug 'bkad/CamelCaseMotion'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'alvan/vim-closetag'
Plug 'embear/vim-localvimrc'
Plug 'janko/vim-test'
Plug 'kburdett/vim-nuuid'
Plug 'arp242/auto_mkdir2.vim'
Plug 'jremmen/vim-ripgrep'
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nacro90/numb.nvim'
Plug 'ziontee113/icon-picker.nvim'

-- Git integration
------------------
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

-- UI / styling
---------------
Plug 'nvim-lualine/lualine.nvim'
Plug 'olimorris/onedarkpro.nvim'
Plug 'edkolev/tmuxline.vim'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ap/vim-css-color'
Plug 'luukvbaal/statuscol.nvim'
Plug 'kevinhwang91/promise-async'
Plug 'kevinhwang91/nvim-ufo'

-- Language specifics
---------------------
-- HTML
-------
Plug 'mattn/emmet-vim'
-- Blade
-------
Plug 'jwalton512/vim-blade' -- No treesitter support for blade yet
-- PHP
------
Plug('phpactor/phpactor', {
    ['for'] = 'php',
    ['tag'] = '*',
    ['do'] = 'composer install --no-dev -o'
})

-- End vim-plug
vim.call('plug#end')



------------
-- CONFIG --
------------


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
-- Configure options to pass to ripgrep when using the :Rg command
vim.g.rg_command = 'rg --vimgrep --smart-case --follow --ignore-vcs --color=never'
-- Start the numb.nvim plugin which previews the line as you type :{number}
require('numb').setup()


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
-- Configure nvim-treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = 'all',
    auto_install = true,
    highlight = {
        enabled = true,
    },
    indent = {
        enabled = true,
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}
-- Configure Comment.nvim
require('Comment').setup {
    pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
}


-- Key mapping
--------------

-- Make <Space> the <Leader> key instead of the default \
vim.g.mapleader = ' '

local utils = require('utils')

-- Hide search highlighting
utils.nmap('<Leader>/', ':nohlsearch<CR>')
-- Disable arrow keys (except in insert mode) - use h,j,k,l
utils.map('<Up>', '<NOP>')
utils.map('<Down>', '<NOP>')
utils.map('<Left>', '<NOP>')
utils.map('<Right>', '<NOP>')
-- Shortcut for vim-easy-align
utils.map('<F2>', '<Plug>(EasyAlign)')
-- Easy window switching
utils.nmap('<C-h>', '<C-w>h')
utils.nmap('<C-j>', '<C-w>j')
utils.nmap('<C-k>', '<C-w>k')
utils.nmap('<C-l>', '<C-w>l')
-- Map CamelCaseMotion to ',w', ',b', ',e', and ',ge'
utils.map(',w', '<Plug>CamelCaseMotion_w')
utils.map(',b', '<Plug>CamelCaseMotion_b')
utils.map(',e', '<Plug>CamelCaseMotion_e')
utils.map(',ge', '<Plug>CamelCaseMotion_ge')
-- Sort the paragraph around the current cursor position (above and below to the nearest blank line) alphabetically
utils.nmap('<Leader>s', '<C-v>apb:sort i<CR>')
-- Sort the selected lines alphabetically
utils.vmap('<Leader>s', ':sort<CR>')
-- Disable default nuuid plugin mappings
vim.g.nuuid_no_mappings = 1

-- Write/quit even if I accidentally hold down shift on :w/:q/:wq
vim.api.nvim_create_user_command('W', ':w<bang>', {})
vim.api.nvim_create_user_command('Q', ':q<bang>', {})
vim.api.nvim_create_user_command('WQ', ':wq<bang>', {})
vim.api.nvim_create_user_command('Wq', ':wq<bang>', {})

-- vim-test mappings
-- Run all tests
utils.nmap('<Leader>ta', ':TestSuite<CR>')
-- Run all tests in current test file
utils.nmap('<Leader>tf', ':TestFile<CR>')
-- Run single test closest to the cursor
utils.nmap('<Leader>tt', ':TestNearest<CR>')
-- Re-run the last run test
utils.nmap('<Leader>tl', ':TestLast<CR>')
-- Go to the last run test
utils.nmap('<Leader>tg', ':TestVisit<CR>')

-- Press Ctrl-q to get back to Normal mode from Terminal mode
utils.tmap('<C-q>', '<C-\\><C-n>')

-- Rg search within files under working directory (results open in quickfix window)
utils.nmap('<Leader>r', ':Rg<Space>')
-- Automatically submit search for word under cursor
utils.nmap('<Leader>R', [[':Rg<Space>' . expand('<cword>') . '<CR>']], { expr = true })

-- Open nvim-tree at the location of the current buffer
utils.nmap('<Leader>n', ':NvimTreeFindFile<CR>')


-- UI / styling
---------------

-- Update the terminal title to the filename
vim.opt.title = true
vim.opt.titlestring = 'nvim - %f'
-- Enable true colour
vim.opt.termguicolors = true
-- Use onedark colorscheme
require('onedarkpro').setup({
    options = {
        cursorline = true,
    },
    styles = {
        comments = 'italic',
        virtual_text = 'italic',
    },
    highlights = {
        GitSignsCurrentLineBlame = {
            -- Highlight the current line blame virtual text as a comment (required to make it italic)
            link = 'Comment',
        },
        htmlBold = {
            cterm = 'bold',
        },
        htmlItalic = {
            cterm = 'italic',
        },
        htmlLink = {
            cterm = 'underline',
        },
    },
})
vim.cmd('colorscheme onedark')
-- Show line numbers
vim.opt.number = true
-- Keep the cursor vertically centered, where possible
vim.opt.scrolloff = 999
-- Draw a vertical line at 120 characters
vim.opt.colorcolumn = '120'
-- Enable indent guides by default
vim.g.indent_guides_enable_on_vim_startup = 1
-- Just use one character to highlight indent level rather than highlighting the full indent block
vim.g.indent_guides_guide_size = 1
-- Start indent guides from level 2 - no need to see it on column 1
vim.g.indent_guides_start_level = 2

-- Setup gitsigns
require('gitsigns').setup {
    numhl = true,
    current_line_blame = true,
    current_line_blame_opts = {
        virt_text_pos = 'eol',
        delay = 500,
    },
    current_line_blame_formatter = '      <author>, <author_time:%Y-%m-%d>  <summary>',
    current_line_blame_formatter_nc = '      Not committed yet',
}

-- Setup nvim-tree
require('nvim-tree').setup()

-- Setup lualine
require('lualine').setup {
    sections = {
        lualine_a = {
            {
                'mode',
                icon = '',
            },
        },
        lualine_b = {'branch', 'diff'},
        lualine_c = {'filename'},

        lualine_x = {
            '%{coc#status()}',
            {
                'diagnostics',
                sources = {'nvim_diagnostic', 'coc', 'ale'},
            },
        },
        lualine_y = {'filetype', 'filesize', 'encoding', 'fileformat'},
        lualine_z = {'%c/%{strwidth(getline("."))}', '%l/%L', 'progress'},
    },
    options = {
        section_separators = {
            left = '',
            right = '',
        },
        component_separators = {
            left = '',
            right = '',
        },
    },
}

-- Setup statuscol
require('statuscol').setup({
    setopt = true,
    separator = ' ',
})

-- Use treesitter for folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- Display folds in the status column (allows clickable folds with statuscol plugin)
vim.opt.foldcolumn = 'auto:3'
-- Limit nested folds to 3 levels deep (any more is unnecessary and makes the fold status column too wide)
vim.opt.foldnestmax = 3
-- Causes folds to be calculated but not collapsed when a buffer is opened (so they're displayed in foldcolumn)
vim.opt.foldlevelstart = 3
-- Modernise fold symbols
vim.opt.fillchars:append('foldopen:,foldsep:│,foldclose:')

-- Telescope
------------

-- TODO: Move this to its own file

require('telescope').setup({
    defaults = {
        mappings = {
            i = {
                ['<C-k>'] = 'move_selection_previous',
                ['<C-j>'] = 'move_selection_next',
            },
            n = {
                ['<C-k>'] = 'move_selection_previous',
                ['<C-j>'] = 'move_selection_next',
            },
        },
        sorting_strategy = 'ascending',
        scroll_strategy = 'limit',
        prompt_prefix = '🔍 ',
        layout_config = {
            prompt_position = 'top',
            width = 0.95,
            height = 0.95,
            preview_width = 0.5,
            scroll_speed = 5, -- number of lines to scroll through the previewer
        },
        dynamic_preview_title = true, -- use the picker result (e.g. file name) as the preview window title
        path_display = {'truncate'}, -- truncate the start of file paths if they are too long to display
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
        }
    }
})
require('telescope').load_extension('fzf')
require('telescope').load_extension('ui-select')
require('telescope').load_extension('coc')
require('icon-picker').setup({
    disable_legacy_commands = true,
})

vim.api.nvim_create_autocmd('User TelescopePreviewerLoaded', {
    command = 'setlocal wrap | setlocal number'
})

-- Open telescope with all available pickers
utils.nmap('<Leader>ft', require('telescope.builtin').builtin)
-- Files under working directory
utils.nmap('<Leader>ff', [[<cmd>lua require('telescope.builtin').find_files({hidden = true})<CR>]])
-- Git files in current repository (including untracked)
utils.nmap('<Leader>fg', [[<cmd>lua require('telescope.builtin').git_files({show_untracked = true})<CR>]])
-- Open buffers
utils.nmap('<Leader>fb', require('telescope.builtin').buffers)
-- Lines in the current buffer
utils.nmap('<Leader>fl', require('telescope.builtin').current_buffer_fuzzy_find)
-- Rg search within files under working directory
utils.nmap('<Leader>fr', require('telescope.builtin').live_grep)
-- Search for the string under the cursor
utils.nmap('<Leader>fR', require('telescope.builtin').grep_string)
-- Modified files
utils.nmap('<Leader>fm', require('telescope.builtin').git_status)
-- Commits affecting current buffer
utils.nmap('<Leader>fc', require('telescope.builtin').git_bcommits)
-- All commits
utils.nmap('<Leader>fC', require('telescope.builtin').git_commits)
-- Icon picker
utils.nmap('<Leader>fi', '<cmd>IconPickerNormal<CR>')
utils.imap('<C-i>', '<cmd>IconPickerNormal<CR>')
-- Fuzzy search LSP symbols (variables, methods, etc found by coc.nvim)
utils.nmap('<Leader>ls', '<cmd>Telescope coc document_symbols<CR>')
-- Fuzzy search LSP definitions
utils.nmap('<Leader>ld', '<cmd>Telescope coc definitions<CR>')
-- Fuzzy search LSP type definitions
utils.nmap('<Leader>lt', '<cmd>Telescope coc type_definitions<CR>')
-- Fuzzy search LSP implementations
utils.nmap('<Leader>li', '<cmd>Telescope coc implementations<CR>')
-- Fuzzy search LSP references
utils.nmap('<Leader>lr', '<cmd>Telescope coc references<CR>')
-- Fuzzy search LSP diagnostics in the buffer (e for error, since d is taken)
utils.nmap('<Leader>le', '<cmd>Telescope coc diagnostics<CR>')
-- Fuzzy search LSP code actions for code under cursor
utils.nmap('<Leader>la', '<cmd>Telescope coc code_actions<CR>')
-- Fuzzy search LSP line-level code actions
utils.nmap('<Leader>lla', '<cmd>Telescope coc line_code_actions<CR>')
-- Fuzzy search LSP file-level code actions
utils.nmap('<Leader>lfa', '<cmd>Telescope coc file_code_actions<CR>')
-- Open Phpactor in telescope
utils.nmap('<Leader>p', '<cmd>PhpactorTelescope<CR>')


-- Other
--------

-- Attempt to improve performance
vim.opt.lazyredraw = true

-- coc.nvim requests that this be low to avoid lag
vim.opt.updatetime = 300

-- Set persistent undo (so undo history is saved even when buffers are closed)
vim.opt.undofile = true

-- List all possible completions, completing to the longest common string first, and then each full match on subsequent
-- presses of <TAB>
vim.opt.wildmode = 'list:longest,full'

-- Use system clipboard by default
vim.opt.clipboard = 'unnamedplus'

-- Make the decisions given when asked before sourcing local vimrc files persistent over multiple vim runs and instances
-- (only if the answer was given in upper case (Y/N/A))
vim.g.localvimrc_persistent = 1
-- Disable lvimrc sandbox so that lvimrc files can include potentially risky commands.
-- This is safe so long as you trust the source of any repos with a lvimrc file.
vim.g.localvimrc_sandbox = 0
-- Search for local config files with these names
vim.g.localvimrc_name = { '.lvimrc', '.local_init.lua' }

-- Run tests with vim-test using the neovim terminal in a split window
vim.g['test#strategy'] = 'neovim'
-- Make it a vertical split
vim.g['test#neovim#term_position'] = 'vertical'
