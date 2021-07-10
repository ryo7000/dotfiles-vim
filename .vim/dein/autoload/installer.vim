function! installer#vimproc()
  echo 'Building: vimproc'
  if executable('make')
    call system('make')
  endif
endfunction

function! installer#cpsm()
  echo 'Building: cpsm'
  if executable('make') && executable('cmake')
    call system('sh -c "PY3=ON ./install.sh"')
  else
    echoe 'install build essentials such as make and cmake, gcc'
  endif
endfunction

function! installer#vim_clap()
  echo 'Building: vim_clap'
  if has('win32') || has('win64')
    call system('powershell.exe .\install.ps1')
  else
    call system('./install.sh')
  end
endfunction
