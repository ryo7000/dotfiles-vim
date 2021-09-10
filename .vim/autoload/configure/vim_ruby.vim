function! configure#vim_ruby#hooks()
  return #{
  \ hook_source: 'call configure#vim_ruby#hook_source()',
  \}
endfunction

function! configure#vim_ruby#hook_source()
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_rails = 1
  let g:rubycomplete_classes_in_global = 1
endfunction
