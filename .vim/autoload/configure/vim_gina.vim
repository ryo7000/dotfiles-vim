function! configure#vim_gina#hooks()
  return #{
  \ hook_post_source: 'call configure#vim_gina#hook_post_source()',
  \}
endfunction

function! configure#vim_gina#hook_post_source()
  " Echo chunk info with j/k
  call gina#custom#mapping#nmap('blame', 'j', 'j<Plug>(gina-blame-echo)')
  call gina#custom#mapping#nmap('blame', 'k', 'k<Plug>(gina-blame-echo)')
endfunction
