function! configure#asyncomplete_buffer#hooks()
  return #{
  \ hook_add: 'call configure#asyncomplete_buffer#hook_add()',
  \}
endfunction

function! configure#asyncomplete_buffer#hook_add()
  au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
      \ 'name': 'b',
      \ 'whitelist': ['*'],
      \ 'blacklist': ['typescript', 'typescript.tsx'],
      \ 'priority': 3,
      \ 'completor': function('asyncomplete#sources#buffer#completor'),
      \ }))
endfunction
