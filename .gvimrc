"---------------------------------------------------------------------------
" gvimrcの設定上書き

set guifont=BDF_M+:h9:cSHIFTJIS
set columns=140
set lines=60
set guioptions-=m
set guioptions-=T

"---------------------------------------------------------------------------
" 補完リストの色
hi Pmenu guibg=grey40
hi PmenuSel guibg=olivedrab
hi PmenuSbar ctermbg=Gray

highlight ZenkakuSpace guibg=gray40
match ZenkakuSpace /　/
