function! configure#cpsm#hooks()
  return #{
  \ hook_post_update: 'call configure#cpsm#hook_post_update()',
  \}
endfunction

function! configure#cpsm#hook_post_update()
  echo 'Building: cpsm'
  if executable('make') && executable('cmake')
    call system('sh -c "PY3=ON ./install.sh"')
  else
    echoe 'install build essentials such as make and cmake, gcc'
  endif
endfunction
