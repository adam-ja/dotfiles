" Extensions to install
let g:coc_global_extensions = [
    \ 'coc-css',
    \ 'coc-docker',
    \ 'coc-highlight',
    \ 'coc-html',
    \ 'coc-json',
    \ 'coc-pairs',
    \ 'coc-phpls',
    \ 'coc-sh',
    \ 'coc-tsserver',
    \ 'coc-vetur',
    \ 'coc-yaml',
    \]

" Highlight symbol under cursor on CursorHold (the conditional avoids errors
" if loading vim before the plugin is installed)
if exists("*CocActionAsync")
    autocmd CursorHold * silent call CocActionAsync('highlight')
endif

" Show documentation in preview window
nnoremap <silent> <Leader>d :call <SID>show_documentation()<CR>

nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"

" Go to definition with Ctrl-]
nmap <silent> <C-]> <Plug>(coc-definition)

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
