au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'f',
    \ 'whitelist': ['*'],
    \ 'priority': 5,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

