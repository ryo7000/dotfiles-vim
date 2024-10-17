function! configure#fern_git_status#hooks()
  return #{
  \ hook_add: 'call configure#fern_git_status#hook_add()',
  \}
endfunction

function! configure#fern_git_status#hook_add()
  let g:fern_git_status#disable_untracked = 1
endfunction

