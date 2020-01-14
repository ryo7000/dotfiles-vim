let g:lsp_diagnostics_echo_cursor = 1
" let g:lsp_log_verbose = 1
" let g:lsp_log_file = expand('/home/ryo/vim-lsp.log')
if executable('typescript-language-server')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'typescript-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'typescript-language-server --stdio']},
        \ 'whitelist': ['typescript', 'typescript.tsx', 'javascript'],
        \ 'root_uri':{server_info->lsp#utils#path_to_uri(lsp#utils#find_nearest_parent_file_directory(lsp#utils#get_buffer_path(), 'tsconfig.json'))},
        \ })
endif
if executable('vls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'vue-language-server',
        \ 'cmd': {server_info->['vls']},
        \ 'whitelist': ['vue'],
        \ 'initialization_options': {
        \   'config': {
        \     'html': {},
        \     'vetur': {
        \       'completion': {
        \         'scaffoldSnippetSources': {}
        \       },
        \       'validation': {}
        \     }
        \   },
        \   'globalSnippetDir': ''
        \ }
        \ })
endif
if executable('ccls')
    " Add clang.resourceDir to initialization_options if the header referenced at ccls build is in another location.
    " via https://github.com/MaskRay/ccls/wiki/Install#clang-resource-directory

    au User lsp_setup call lsp#register_server({
        \ 'name': 'ccls',
        \ 'cmd': {server_info->['ccls']},
        \ 'root_uri': {server_info->lsp#utils#path_to_uri(
        \    lsp#utils#find_nearest_parent_file_directory(
        \        lsp#utils#get_buffer_path(),
        \        ['.ccls', 'compile_commands.json']
        \    ))},
        \ 'initialization_options': #{
        \    cache: #{directory: '/tmp/ccls-cache'},
        \    completion: #{detailedLabel: v:false}
        \ },
        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp', 'cc'],
        \ })
endif
if executable('gopls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'gopls',
        \ 'cmd': {server_info->['gopls']},
        \ 'whitelist': ['go'],
        \ 'workspace_config': #{gopls: #{
        \   staticcheck: v:true,
        \   completeUnimported: v:true,
        \   caseSensitiveCompletion: v:true,
        \   usePlaceholders: v:true,
        \   completionDocumentation: v:true,
        \   watchFileChanges: v:true,
        \   hoverKind: 'SingleLine',
        \ }}
        \ })
endif
if executable('rls')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'workspace_config': {'rust': {'clippy_preference': 'on'}},
        \ 'whitelist': ['rust'],
        \ })
endif

function! s:on_lsp_buffer_enabled() abort
    nmap <buffer> <C-]> <plug>(lsp-definition)
    nmap <buffer> gd <plug>(lsp-definition)
    nmap <buffer> gD <plug>(lsp-references)
    nmap <buffer> gs <plug>(lsp-document-symbol)
    nmap <buffer> gS <plug>(lsp-workspace-symbol)
    nmap <buffer> gQ <plug>(lsp-document-format)
    vmap <buffer> gQ <plug>(lsp-document-format)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <F1> <plug>(lsp-implementation)
    nmap <buffer> <F2> <plug>(lsp-rename)
endfunction

augroup lsp_float_colours
    autocmd!
    autocmd User lsp_float_opened call win_execute(lsp#ui#vim#output#getpreviewwinid(), 'setlocal wincolor=SignColumn')
augroup end

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

