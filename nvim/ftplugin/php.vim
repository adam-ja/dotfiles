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
" Goto definition of class or class member under the cursor
autocmd FileType php nmap <buffer> <silent> <C-]> :call PhpGoToDefinition()<CR>

if !exists('*PhpGoToDefinition')
    " Without the exists check, we end up trying to redefine the function
    " while it is in use when we open another PHP file by jumping to a
    " definition in said file, causing an error.
    function! PhpGoToDefinition ()
        call phpactor#GotoDefinition()
        " In case PHPActor can't find a definition, try CoC instead.  If
        " PHPActor succeeds, this will still be called but nothing happens as
        " we've already jumped to the definition.  Haven't figured out yet how
        " to detect the error from PHPActor to make this conditional.
        call CocAction('jumpDefinition')
    endfunction
endif

" Misc
"------

" Wrap lines at 120 characters
setlocal textwidth=120
