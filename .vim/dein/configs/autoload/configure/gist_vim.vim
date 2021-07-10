function! configure#gist_vim#hooks()
  return #{
  \ hook_add: 'call configure#gist_vim#hook_add()',
  \}
endfunction

function! configure#gist_vim#hook_add()
  let g:gist_post_private = 1
endfunction
