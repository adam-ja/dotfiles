" Wait a second for me to finish typing before linting
let g:ale_lint_delay = 1000
" Show ale info in statusline
let g:airline#extensions#ale#enabled = 1
" Show linter at beginning of message
let g:ale_echo_msg_format = '[%linter%] %s'
" Show messages in a floating preview window
let g:ale_cursor_detail = 1
let g:ale_floating_preview = 1
let g:ale_floating_window_border = ['│', '─', '╭', '╮', '╯', '╰', '│', '─']
let g:ale_close_preview_on_insert = 1
" Disable LSP features in ALE as these are handled by another plugin
let g:ale_disable_lsp = 1
" Make ale error/warning gutter symbols prettier
let g:ale_sign_error = '😠'
let g:ale_sign_warning = '😒'

""""""""""""""""
" Key Mappings "
""""""""""""""""

" Move to the previous warning/error
nmap <silent> <Leader>j <Plug>(ale_previous_wrap)
" Move to the next warning/error
nmap <silent> <Leader>k <Plug>(ale_next_wrap)
" Disable in all buffers
nmap <Leader>ad :ALEDisable<CR>
" Disable in current buffer
nmap <Leader>abd :ALEDisableBuffer<CR>
" Enable in all buffers
nmap <Leader>ae :ALEEnable<CR>
" Enable in current buffer
nmap <Leader>abe :ALEEnableBuffer<CR>
