function! configure#vimproc#hooks()
  return #{
  \ do: { -> configure#vimproc#do() },
  \}
endfunction

function! configure#vimproc#do()
  echo 'Building: vimproc'
  if executable('make')
    call system('make')
  endif
endfunction

