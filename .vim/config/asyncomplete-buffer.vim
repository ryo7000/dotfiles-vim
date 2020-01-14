au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'b',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['typescript', 'typescript.tsx'],
    \ 'priority': 3,
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))
