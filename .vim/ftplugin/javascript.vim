set ts=2 sw=2 sts=2 et

call configure#coc#add_extensions(['coc-tsserver'])

augroup Javascript
  autocmd!
  " Use this instead of coc.preferences.formatOnSaveFiletypes to avoid timeout
  " https://github.com/neoclide/coc.nvim/issues/3441
  autocmd BufWritePre *.js,*.jsx silent :call CocAction('format')
augroup end
