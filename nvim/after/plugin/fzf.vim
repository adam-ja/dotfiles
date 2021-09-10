" Open fzf in a floating window taking up 90% of the horizontal and vertical
" space
let g:fzf_layout = { 'window' : { 'width' : 0.9, 'height' : 0.9 } }

""""""""""""
" Commands "
""""""""""""

" Add a preview to the :Files command
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" Add a preview to the :Rg command
command! -bang -nargs=* Rgfzf
    \ call fzf#vim#grep('rg --column --no-heading --line-number --color=always '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)

""""""""""""""""
" Key Mappings "
""""""""""""""""

" Lines in the current buffer
nmap <Leader>fl :BLines<CR>

" Files under working directory
nmap <Leader>ff :Files<CR>

" Open buffers
nmap <Leader>fb :Buffers<CR>

" Rg search within files under working directory (results open in fzf preview)
nmap <Leader>fr :Rgfzf<Space>
" Automatically submit search for word under cursor
nmap <expr> <Leader>fR ':Rgfzf<Space>'.expand('<cword>').'<cr>'

" Modified files
nmap <Leader>fm :GFiles?<CR>

" Commits affecting current buffer
nmap <Leader>fc :BCommits<CR>

" All commits
nmap <Leader>fC :Commits<CR>

" Fuzzy search LSP symbols (variables, methods, etc found by coc.nvim)
nmap <Leader>fs :Vista finder coc<CR>
