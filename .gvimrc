colorscheme desert

" Font {{{1

if has('win32')
  set guifont=BDF_M+:h9:cSHIFTJIS
endif

" Options {{{1

set columns=140
set lines=60

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

"---------------------------------------------------------------------------
" �⊮���X�g�̐F
hi Pmenu guibg=grey40
hi PmenuSel guibg=olivedrab
hi PmenuSbar ctermbg=Gray

highlight ZenkakuSpace guibg=gray40
au BufRead,BufNew * match ZenkakuSpace /�@/

" vim: et sts=2 sw=2 fdm=marker fdc=3
