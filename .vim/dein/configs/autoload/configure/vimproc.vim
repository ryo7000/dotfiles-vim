function! configure#vimproc#hooks()
  return #{
  \ hook_post_update: 'call configure#vimproc#hook_post_update()',
  \}
endfunction

function! configure#vimproc#hook_post_update()
  echo 'Building: vimproc'
  if executable('make')
    call system('make')
  endif
endfunction

