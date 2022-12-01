function! configure#lucius#hooks()
  return #{
  \ hook_add: 'call configure#lucius#hook_add()',
  \}
endfunction

function! configure#lucius#hook_add()
  if !exists('g:colors_name')
    " syntax enable, set backgroundでcolorschmeが再loadされるため先に設定
    syntax enable
    set background=dark
    colorscheme lucius
  endif
endfunction
