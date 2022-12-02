function! configure#lightline_coc#hooks()
  return #{
  \ hook_add: 'call configure#lightline_coc#hook_add()',
  \}
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

  call add(g:lightline.active.left, ['coc_info', 'coc_hints', 'coc_errors', 'coc_warnings'])
  call add(g:lightline.active.right, ['coc_status'])
  call lightline#coc#register()
endfunction
