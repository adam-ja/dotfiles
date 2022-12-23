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

-- Fuzzy finder
---------------
Plug('junegunn/fzf', {['do'] = vim.fn['fzf#install']})
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'

-- Syntax
---------
Plug 'dense-analysis/ale'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.cmd['TSUpdate']})
Plug('neoclide/coc.nvim', {branch = 'release'})
Plug 'kamykn/spelunker.vim'
Plug 'kamykn/popup-menu.nvim'
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
Plug 'mg979/vim-visual-multi'
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
Plug 'preservim/nerdtree'
Plug 'nacro90/numb.nvim'

-- Git integration
------------------
Plug 'tpope/vim-fugitive'
Plug 'lewis6991/gitsigns.nvim'

-- UI / styling
---------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'olimorris/onedarkpro.nvim'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'nathanaelkane/vim-indent-guides'

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
-- Use treesitter for folding
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'nvim_treesitter#foldexpr()'
-- Do not close folds by default when opening a file
vim.opt.foldenable = false


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
-- Only highlight mis-spelled words (not rare, mis-capitalised, or words from a different language region)
vim.g.spelunker_highlight_type = 2


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

-- Open NERDTree at the location of the current buffer
utils.nmap('<Leader>n', ':NERDTreeFind<CR>')


-- UI / styling
---------------

-- Update the terminal title to the filename
vim.opt.title = true
vim.opt.titlestring = '%f - nvim'
-- Enable true colour
vim.opt.termguicolors = true
-- Use onedark colorscheme
require('onedarkpro').setup({
    options = {
        cursorline = true,
    },
})
vim.cmd('colorscheme onedark_vivid')
-- Use powerline font for nice VCS symbols for vim-airline
vim.g.airline_powerline_fonts = 1
-- Use onedark airline theme
vim.g.airline_theme = 'onedark'
-- Disable airline scrollbar extension - takes up unnecessary space
vim.g['airline#extensions#scrollbar#enabled'] = 0
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
        virt_text_pos = 'right_align',
        delay = 500,
    },
}


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
