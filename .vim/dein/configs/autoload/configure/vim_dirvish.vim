function! configure#vim_dirvish#hooks()
  return #{
  \ hook_add: 'call configure#vim_dirvish#hook_add()',
  \}
endfunction

function! configure#vim_dirvish#hook_add()
  " Sort folders at the top
  let g:dirvish_mode = ':sort ,^.*[\/],'
endfunction
