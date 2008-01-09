if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if version < 600
  so <sfile>:p:h/php.vim
else
  runtime! syntax/php.vim
  unlet b:current_syntax
endif

let b:current_syntax = "symfony"
