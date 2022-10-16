function! configure#ambiwidth#hooks()
  return #{
  \ hook_post_source: 'call configure#ambiwidth#hook_post_source()',
  \}
endfunction

function! configure#ambiwidth#hook_post_source()
  " override following width for lightline
  " 
  " 
  " 
  " 
  call setcellwidths([[0xe0a0, 0xe0a3, 1]])
endfunction
