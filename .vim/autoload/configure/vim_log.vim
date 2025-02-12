function! configure#vim_log#hooks()
  return #{
  \ hook_post_source: 'call configure#vim_log#hook_post_source()',
  \}
endfunction

function! configure#vim_log#hook_post_source()
  augroup VimLogEsp32
    au!
    au Syntax log syn match logLevelInfoConceal /^\%x1b\[0;32m.*\(\%x1b\[0m\)\?\r$/ contains=concealAnsiColorStart,concealAnsiResetConceal,logString,logNumber keepend
    au Syntax log syn match logLevelWarning /^\%x1b\[0;33m.*\%x1b\[0m\r$/ contains=concealAnsiColorStart,concealAnsiResetConceal,logString,logNumber keepend
    au Syntax log syn match logLevelError /^\%x1b\[0;31m.*\%x1b\[0m\r$/ contains=concealAnsiColorStart,concealAnsiResetConceal,logString,logNumber keepend

    au Syntax log syn match concealAnsiColorStart /^\%x1b\[0;3[1-3]m/ contained conceal
    au Syntax log syn match concealAnsiResetConceal /\%x1b\[0m\r$/ contained conceal

    au Syntax log set conceallevel=2 concealcursor=n
  augroup END
endfunction
