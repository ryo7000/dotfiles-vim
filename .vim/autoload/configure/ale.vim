function! configure#ale#hooks()
  return #{
  \ hook_add: 'call configure#ale#hook_add()',
  \}
endfunction

function! configure#ale#hook_add()
  let g:ale_echo_msg_error_str = 'E'
  let g:ale_echo_msg_warning_str = 'W'
  let g:ale_echo_msg_format = 'ALE: [%linter%][%severity%]%[code]% %s '
  let g:ale_disable_lsp = 1
  let g:ale_linters_explicit = 1
  let g:ale_fixers = {
  \  'javascript': ['prettier'],
  \  'javascriptreact': ['prettier'],
  \  'typescript': ['prettier'],
  \  'typescriptreact': ['prettier'],
  \  'vue': ['prettier'],
  \}
  let g:ale_fix_on_save = 1

  let g:ale_linters = {
  \   'html': ['htmlhint'],
  \   'javascript': ['eslint'],
  \   'javascriptreact': ['eslint'],
  \   'typescript': ['eslint'],
  \   'typescriptreact': ['eslint'],
  \   'vue': ['vls'],
  \   'php': ['phpcs', 'phpstan'],
  \   'go' : ['go vet'],
  \}

  " C/C++
  " for handling c++ header with clang-tidy
  let g:ale_c_parse_compile_commands = 1
  " for clang-tidy to recognize .h file as c++ header
  let g:ale_cpp_clangtidy_options = '-x c++'

  " php
  let g:ale_php_phpcs_options = '--standard=PSR2'

  " lightline
  let s:lightline = {
  \  'component_expand': {
  \    'linter_warnings': 'lightline#ale#warnings',
  \    'linter_errors': 'lightline#ale#errors',
  \    'linter_ok': 'lightline#ale#ok',
  \  }
  \}

  if exists("g:lightline")
    call extend(g:lightline, s:lightline)
  else
    let g:lightline = s:lightline
  end
endfunction
