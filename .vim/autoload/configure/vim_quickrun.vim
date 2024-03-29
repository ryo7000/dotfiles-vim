function! configure#vim_quickrun#hooks()
  return #{
  \ hook_add: 'call configure#vim_quickrun#hook_add()',
  \}
endfunction

function! configure#vim_quickrun#hook_add()
  let g:quickrun_config = {
  \  "_" : {
  \      "runner" : "vimproc",
  \      "runner/vimproc/updatetime" : 60,
  \      "outputter" : "error",
  \      "outputter/error/success" : "buffer",
  \      "outputter/error/error" : "quickfix"
  \ },
  \ 'cpp': {
  \   'cmdopt': '-std=c++14',
  \ },
  \ 'rust': {
  \   'type': 'rust/cargo',
  \ },
  \}
endfunction
