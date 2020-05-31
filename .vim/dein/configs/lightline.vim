function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunc

function! s:LightlineMode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! s:LightlineModified()
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! s:LightlineFugitive()
  if &ft !~? 'vimfiler' && exists("*FugitiveHead")
    let _ = FugitiveHead()
    return strlen(_) ? "\ue0a0 "._ : ''
  endif
  return ''
endfunction

function! s:LightlineReadonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? "\ue0a2" : ''
endfunction

function! s:LightlineFilename()
  return ('' != s:LightlineReadonly() ? s:LightlineReadonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() :
        \  &ft == 'unite' ? unite#get_status_string() :
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \  &ft == 'qf' ? '[qf] '. w:quickfix_title :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != s:LightlineModified() ? ' ' . s:LightlineModified() : '')
endfunction

let s:sid = s:SID()
let s:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left':  [['mode', 'paste'], ['fugitive', 'filename']],
\   'right': [['lineinfo'], ['percent'],
\             ['fileformat', 'fileencoding', 'filetype'],
\             ['linter_errors', 'linter_warnings', 'linter_ok']]
\ },
\ 'component': {
\   'readonly': '%{&readonly?"\u2b64":""}',
\ },
\ 'component_function': {
\   'mode': printf('<SNR>%d_LightlineMode', s:sid),
\   'readonly': printf('<SNR>%d_LightlineReadonly', s:sid),
\   'fugitive': printf('<SNR>%d_LightlineFugitive', s:sid),
\   'filename': printf('<SNR>%d_LightlineFilename', s:sid),
\ },
\ 'component_type': {
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'linter_ok': 'left',
\ },
\ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
\ }

if exists("g:lightline")
  call extend(g:lightline, s:lightline)
else
  let g:lightline = s:lightline
end

