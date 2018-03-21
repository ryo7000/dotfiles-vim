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
" ���{����͂Ɋւ���ݒ�:
"
if has('multi_byte_ime') || has('xim')
  " IME ON���̃J�[�\���̐F��ݒ�(�ݒ��:��)
  highlight CursorIM guibg=Purple guifg=NONE
  " �}�����[�h�E�������[�h�ł̃f�t�H���g��IME��Ԑݒ�
  set iminsert=0 imsearch=0
  if has('xim') && has('GUI_GTK')
    " XIM�̓��͊J�n�L�[��ݒ�:
    " ���L�� s-space ��Shift+Space�̈Ӗ���kinput2+canna�p�ݒ�
    "set imactivatekey=s-space
  endif
  " �}�����[�h�ł�IME��Ԃ��L�������Ȃ��ꍇ�A���s�̃R�����g������
  "inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

highlight ZenkakuSpace guibg=gray40
au BufRead,BufNew * match ZenkakuSpace /�@/

" vim: et sts=2 sw=2 fdm=marker fdc=3
