function! configure#tagbar#hooks()
  return #{
  \ hook_add: 'call configure#tagbar#hook_add()',
  \}
endfunction

function! configure#tagbar#hook_add()
  let g:tagbar_left = 1
  nmap <C-w><C-t> :TagbarToggle<cr>
endfunction
