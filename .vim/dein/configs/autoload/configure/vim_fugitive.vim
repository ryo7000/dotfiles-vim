function! configure#vim_fugitive#hooks()
  return #{
  \ hook_add: 'call configure#vim_fugitive#hook_add()',
  \}
endfunction

function! s:diff_hash(hash) abort
  execute 'Gedit ' . a:hash . ':%'
  execute 'Gdiffsplit ' . a:hash . '^:%'
endfunction

function! configure#vim_fugitive#hook_add()
  command! -nargs=1 GdiffHash call s:diff_hash(<q-args>)
endfunction
