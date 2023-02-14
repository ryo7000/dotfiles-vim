function! configure#fern#hooks()
  return #{
  \ hook_add: 'call configure#fern#hook_add()',
  \}
endfunction

function! s:init_fern() abort
  nmap <buffer> - <Plug>(fern-action-leave)
endfunction

function! configure#fern#hook_add()
  let g:fern#default_hidden = 1
  let g:fern#keepalt_on_edit = 1
  let g:fern#keepjumps_on_edit = 1
  nmap <silent> - :<C-U> Fern %:h -reveal=%<CR>

  augroup fern-custom
    autocmd! *
    autocmd FileType fern call s:init_fern()
  augroup END
endfunction
