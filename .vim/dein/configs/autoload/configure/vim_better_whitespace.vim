function! configure#vim_better_whitespace#hooks()
  return #{
  \ hook_add: 'call configure#vim_better_whitespace#hook_add()',
  \}
endfunction

function! configure#vim_better_whitespace#hook_add()
  let g:better_whitespace_filetypes_blacklist = ['diff']
endfunction
