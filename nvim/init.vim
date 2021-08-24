""""""""""""
"  VIM-PLUG  "
""""""""""""
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Initialise vim-plug to install plugins
call plug#begin()

" Fuzzy finder
"-----------------
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'liuchengxu/vista.vim'

" Syntax
"--------
Plug 'dense-analysis/ale'
Plug 'sheerun/vim-polyglot'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kamykn/spelunker.vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'luochen1990/rainbow'
Plug 'wellle/context.vim'

" Utilities
"-----------
Plug 'vim-scripts/SearchComplete'
Plug 'bkad/CamelCaseMotion'
Plug 'junegunn/vim-easy-align'
Plug 'mg979/vim-visual-multi'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-commentary'
Plug 'alvan/vim-closetag'
Plug 'embear/vim-localvimrc'
Plug 'janko/vim-test'
Plug 'kburdett/vim-nuuid'
Plug 'arp242/auto_mkdir2.vim'
" Use patched version of vim-ripgrep until this is merged
" Plug 'jremmen/vim-ripgrep'
Plug 'lamchau/vim-ripgrep', {'branch': 'patch-1'}
Plug 'stefandtw/quickfix-reflector.vim'
Plug 'AndrewRadev/splitjoin.vim'
Plug 'preservim/nerdtree'

" Git integration
"-----------------
Plug 'tpope/vim-fugitive'
Plug 'mhinz/vim-signify'

" UI / styling
"--------------
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'joshdick/onedark.vim'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'nathanaelkane/vim-indent-guides'

" Language specifics
"--------------------
" HTML
" -----
Plug 'mattn/emmet-vim'
" PHP
" ----
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}

" End vim-plug
call plug#end()



""""""""""""
"  CONFIG  "
""""""""""""


" Indentation
"-------------

" Tabs = 4 spaces
set tabstop=4
" Delete 4 spaces with backspace
set softtabstop=4
" Use 4 spaces for (auto)indentation
set shiftwidth=4
" Convert tabs to spaces
set expandtab
" Automatically indent new lines to match the one above
set autoindent
" Make backspace work properly (e.g. traverse line breaks)
set backspace=indent,eol,start
" Fold automatically by indentation
set foldmethod=indent
" Do not close folds by default when opening a file
set nofoldenable


" Search
"--------

" Highlight all matches for a search term
set hlsearch
" Make search case-insensitive
set ignorecase
" Search as you type
set incsearch
" Configure options to pass to ripgrep when using the :Rg command
let g:rg_command = 'rg --vimgrep --smart-case --follow --ignore-vcs --color=never'


" Syntax
"--------

" Turn on syntax highlighting
syntax on
" Enable filetype specific plugins and auto indentation
filetype plugin indent on
" Display whitespace
set list
" Highlight tabs and trailing spaces
set listchars=tab:\|·,trail:`
" Remove trailing spaces when saving a buffer
autocmd BufWritePre * :call Preserve("%s/\\s\\+$//e")
" When a bracket is inserted, briefly jump to the matching one
set showmatch
" Extended % matching (if/else, XML tags, etc as well as standard brackets)
runtime macros/matchit.vim
" Enable rainbow parentheses
let g:rainbow_active = 1
" Only highlight mis-spelled words (not rare, mis-capitalised, or words from a
" different language region)
let g:spelunker_highlight_type = 2


" Key mapping
"-------------

" Make <Space> the <Leader> key instead of the default \
let mapleader = ' '

" Hide search highlighting
nnoremap <silent> <Leader>/ :nohlsearch<CR>
" Disable arrow keys (except in insert mode) - use h,j,k,l
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
" Shortcut for vim-easy-align
map <F2> <Plug>(EasyAlign)
" Toggle paste mode on/off with F3
set pastetoggle=<F3>
" Easy window switching
nmap <C-h> <C-w>h
nmap <C-j> <C-w>j
nmap <C-k> <C-w>k
nmap <C-l> <C-w>l
" Map CamelCaseMotion to ',w', ',b', ',e', and ',ge'
map ,w <Plug>CamelCaseMotion_w
map ,b <Plug>CamelCaseMotion_b
map ,e <Plug>CamelCaseMotion_e
map ,ge <Plug>CamelCaseMotion_ge
" Sort the paragraph around the current cursor position (above and below to the
" nearest blank line) in alphabetical order
nnoremap <Leader>s <C-v>apb:sort i<CR>
" Sort the selected lines in alphabetical order
vnoremap <Leader>s :sort<CR>
" Disable default nuuid plugin mappings
let g:nuuid_no_mappings = 1

" Write/quit even if I accidentally hold down shift on :w/:q/:wq
command! -bang W :w<bang>
command! -bang Q :q<bang>
command! -bang WQ :wq<bang>
command! -bang Wq :wq<bang>

" vim-test mappings
" Run all tests
nmap <Leader>ta :TestSuite<CR>
" Run all tests in current test file
nmap <Leader>tf :TestFile<CR>
" Run single test closest to the cursor
nmap <Leader>tt :TestNearest<CR>
" Re-run the last run test
nmap <Leader>tl :TestLast<CR>
" Go to the last run test
nmap <Leader>tg :TestVisit<CR>

" Rg search within files under working directory (results open in quickfix window)
nmap <Leader>r :Rg<Space>
" Automatically submit search for word under cursor
nmap <expr> <Leader>R ':Rg<Space>'.expand('<cword>').'<cr>'

" Open NERDTree at the location of the current buffer
nmap <Leader>n :NERDTreeFind<CR>

" UI / styling
"--------------

" Enable true colour
" https://github.com/tmux/tmux/issues/1246
let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
" Use onedark colorscheme
colorscheme onedark
" Use powerline font for nice VCS symbols for vim-airline
let g:airline_powerline_fonts=1
" Disable airline scrollbar extension - takes up unnecessary space
let g:airline#extensions#scrollbar#enabled = 0
" Automatically change the screen title
set title
" Show line numbers
set number
" Show the current cursor position in the status line
set ruler
" Always show the status line
set laststatus=2
" Keep the cursor vertically centered, where possible
set scrolloff=999
" Highlight the line the cursor is currently on
set cursorline
" Draw a vertical line at 120 characters
set colorcolumn=120
" Enable indent guides by default
let g:indent_guides_enable_on_vim_startup = 1
" Just use one character to highlight indent level rather than highlighting
" the full indent block
let g:indent_guides_guide_size = 1
" Start indent guides from level 2 - no need to see it on column 1
let g:indent_guides_start_level = 2

" Other
"-------

" Attempt to improve performance
set lazyredraw

" coc.nvim requests that this be low to avoid lag
set updatetime=300

" Set persistent undo (so undo history is saved even when buffers are closed)
set undodir=~/.vim-undo
set undofile

" Hide (rather than close) abandoned buffers, to preserve undos and remember unsaved changes
set hidden

" Show possible completions in command mode with <TAB>
set wildmenu

" List all possible completions, completing to the longest common string
" first, and then each full match on subsequent presses of <TAB>
set wildmode=list:longest,full

" Use system clipboard by default
set clipboard+=unnamedplus

" Make the decisions given when asked before sourcing local vimrc files
" persistent over multiple vim runs and instances (only if the answer was given
" in upper case (Y/N/A))
let g:localvimrc_persistent=1

" Disable lvimrc sandbox so that lvimrc files can include potentially risky
" commands. This is safe so long as you trust the source of any repos with a
" lvimrc file.
let g:localvimrc_sandbox = 0

" Run tests with vim-test using the neovim terminal in a split window
let test#strategy = 'neovim'
" Make it a vertical split
let test#neovim#term_position = 'vertical'


" Functions
"-----------

" http://technotales.wordpress.com/2010/03/31/preserve-a-vim-function-that-keeps-your-state/
function! Preserve(command)
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    execute a:command
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
