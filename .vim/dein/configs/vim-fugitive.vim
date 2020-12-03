function! s:diff_hash(hash) abort
  execute 'Gedit ' . a:hash . ':%'
  execute 'Gdiffsplit ' . a:hash . '^:%'
endfunction

command! -nargs=1 GdiffHash call s:diff_hash(<q-args>)
