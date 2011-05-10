set ts=2 sw=2 sts=2 et

function! MagicComment()
  return "# -*- coding: utf-8 -*-\<CR>"
endfunction

inoreabbrev <buffer> ## <C-R>=MagicComment()<CR>
