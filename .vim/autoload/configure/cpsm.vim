function! configure#cpsm#hooks()
  return #{
  \ do: { -> configure#cpsm#do() },
  \}
endfunction

function! configure#cpsm#do()
  echo 'Building: cpsm'
  if executable('make') && executable('cmake')
    call system('sh -c "PY3=ON ./install.sh"')
  else
    echoe 'install build essentials such as make and cmake, gcc'
  endif
endfunction
