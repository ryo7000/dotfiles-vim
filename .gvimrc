colorscheme lucius
let g:lucius_contrast = 'low'
set background="dark"

" Font {{{1

if has('win32')
  if has('directx')
    " TODO: renderingoptions and values will changed in official release
    set renderoptions=type:directx,renmode:5
    set guifont=Ricty_for_Powerline:h14:cSHIFTJIS
  else
    set guifont=BDF_M+:h9:cSHIFTJIS
  endif
elseif has('unix')
  set guifont=Ricty\ 11
endif

" Options {{{1

set columns=140
set lines=50

" Mappings {{{1

" Make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" Etc {{{1

"---------------------------------------------------------------------------
" 日本語入力に関する設定:
"
if has('multi_byte_ime') || has('xim')
  " IME ON時のカーソルの色を設定(設定例:紫)
  highlight CursorIM guibg=Purple guifg=NONE
  " 挿入モード・検索モードでのデフォルトのIME状態設定
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIMの入力開始キーを設定:
    " 下記の s-space はShift+Spaceの意味でkinput2+canna用設定
    "set imactivatekey=s-space
  endif
  " 挿入モードでのIME状態を記憶させない場合、次行のコメントを解除
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

highlight ZenkakuSpace guibg=gray40
au BufRead,BufNew * match ZenkakuSpace /　/

" vim: et sts=2 sw=2 fdm=marker fdc=3
