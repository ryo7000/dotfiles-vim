function! configure#asyncomplete_file#hooks()
  return #{
  \ hook_add: 'call configure#asyncomplete_file#hook_add()',
  \}
endfunction

function! configure#asyncomplete_file#hook_add()
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
      \ 'name': 'f',
      \ 'whitelist': ['*'],
      \ 'priority': 5,
      \ 'completor': function('asyncomplete#sources#file#completor')
      \ }))
endfunction
