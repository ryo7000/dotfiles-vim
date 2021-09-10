function! configure#eregex#hooks()
  return #{
  \ hook_add: 'call configure#eregex#hook_add()',
  \}
endfunction

function! configure#eregex#hook_add()
  let g:eregex_default_enable = 0
endfunction
