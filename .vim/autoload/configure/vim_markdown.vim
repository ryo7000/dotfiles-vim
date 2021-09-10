function! configure#vim_markdown#hooks()
  return #{
  \ hook_source: 'call configure#vim_markdown#hook_source()',
  \}
endfunction

function! configure#vim_markdown#hook_source()
  let g:vim_markdown_folding_disabled = 1
  let g:vim_markdown_toc_autofit = 1
endfunction
