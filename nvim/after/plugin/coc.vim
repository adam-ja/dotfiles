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

" Stop the cursor disappearing after running some coc commands
let g:coc_disable_transparent_cursor = 1

" Highlight symbol under cursor on CursorHold (the conditional avoids errors
" if loading vim before the plugin is installed)
if exists("*CocActionAsync")
    autocmd CursorHold * silent call CocActionAsync('highlight')
endif

" Show documentation in preview window
nnoremap <silent> <Leader>d :call <SID>show_documentation()<CR>

nnoremap <nowait><expr> <C-j> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-j>"
nnoremap <nowait><expr> <C-k> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-k>"

" Go to definition with Ctrl-] maintained for muscle memory
nmap <silent> <C-]> <Plug>(coc-definition)
nmap <silent> <Leader>cgd <Plug>(coc-definition)
nmap <silent> <Leader>cgt <Plug>(coc-type-definition)
nmap <silent> <Leader>cgi <Plug>(coc-implementation)
nmap <silent> <Leader>cgr <Plug>(coc-references)

" Applying codeAction to the selected region.
" Example: `<Leader>caap` for current paragraph
xmap <Leader>ca  <Plug>(coc-codeaction-selected)
nmap <Leader>ca  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>cba  <Plug>(coc-codeaction)

" Run the Code Lens action on the current line.
nmap <Leader>cl  <Plug>(coc-codelens-action)

function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    else
        call CocAction('doHover')
    endif
endfunction
