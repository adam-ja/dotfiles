" ALE
"-----

" Set phpcs standard
let g:ale_php_phpcs_standard = 'PSR12'
" Set phpstan to level 5
let g:ale_php_phpstan_level = 5

" PHPActor
"----------

" Include use statement
autocmd FileType php nmap <buffer> <silent> <Leader>u :call phpactor#UseAdd()<CR>
" Invoke the context menu
autocmd FileType php nmap <buffer> <silent> <Leader>mm :call phpactor#ContextMenu()<CR>

" Misc
"------

" Wrap lines at 120 characters
setlocal textwidth=120
