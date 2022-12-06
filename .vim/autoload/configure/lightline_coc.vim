function! configure#lightline_coc#hooks()
  return #{
  \ hook_add: 'call configure#lightline_coc#hook_add()',
  \}
endfunction

" lightline#coc#status not replace % signs
function! configure#lightline_coc#coc_status()
  return substitute(lightline#coc#status(), '%', '%%', 'g')
endfunction

function! configure#lightline_coc#hook_add()
  if (!exists("g:lightline"))
    throw 'load after g:lightline setting'
  end

  let g:lightline#coc#indicator_errors = 'E'
  let g:lightline#coc#indicator_warnings = 'W'
  let g:lightline#coc#indicator_info = 'I'
  let g:lightline#coc#indicator_hints = 'H'
  let g:lightline#coc#indicator_ok = 'OK'

  let lightline = {
  \ 'component_expand': {
  \   'coc_status': 'configure#lightline_coc#coc_status',
  \   'coc_warnings': 'lightline#coc#warnings',
  \   'coc_errors': 'lightline#coc#errors',
  \   'coc_info': 'lightline#coc#info',
  \   'coc_hints': 'lightline#coc#hints',
  \   'coc_ok': 'lightline#coc#ok',
  \ },
  \ 'component_type': {
  \   'coc_status': 'info',
  \   'coc_warnings': 'warning',
  \   'coc_errors': 'error',
  \   'coc_info': 'info',
  \   'coc_hints': 'hint',
  \   'coc_ok': 'left',
  \ },
  \ }

  if exists("g:lightline")
    call extend(g:lightline, lightline)
  else
    let g:lightline = lightline
  end

  call add(g:lightline.active.left, ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings'])
  call add(g:lightline.active.right, ['coc_status'])
endfunction
