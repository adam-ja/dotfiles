" Prevent the CSV plugin included in vim-polyglot (chrisbra/csv.vim) from
" setting its mappings as they conflict with my own and I don't need them.
let g:no_csv_maps = 1

" Arrange the file into a table layout for easier reading and fix the header
" to the top. The `` jumps the cursor back to the line it was on before
" arranging
nmap <Leader>a ggVG:CSVArrangeColumn<CR>``:silent! Header<CR>
" Un-arrange the file for saving as a regular CSV without all the spaces added
" for table layout, and remove the fixed header from the top.
nmap <Leader>u ggVG:CSVUnArrangeColumn<CR>``:Header!<CR>
