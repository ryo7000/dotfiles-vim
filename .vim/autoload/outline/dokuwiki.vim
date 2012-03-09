"=============================================================================
" File       : autoload/unite/sources/outline/defaults/dokuwiki.vim
" Author     : ryo7000
" Maintainer : ryo7000 <ryo7000@gmail.com>
" Updated    : 2012-03-07
"
" Licensed under the MIT license:
" http://www.opensource.org/licenses/mit-license.php
"
"=============================================================================

" Default outline info for dokuwiki
" Version: 0.0.1

"function! unite#sources#outline#defaults#dokuwiki#outline_info()
function! outline#dokuwiki#outline_info()
  return s:outline_info
endfunction

"-----------------------------------------------------------------------------
" Outline Info

let s:outline_info = {
      \ 'heading': '^=\{2,6}',
      \ }

function! s:outline_info.create_heading(which, heading_line, matched_line, context)
  let heading = {
        \ 'word' : substitute(a:heading_line, '^[= ]\+\(.\{-}\)[ =]\+$', '\1', 'g'),
        \ 'level': s:get_level(matchstr(a:heading_line, '^ \=\zs=\{2,6}\ze')),
        \ 'type' : 'generic',
        \ }
  return heading
endfunction

function! s:get_level(str)
  return abs(strlen(a:str) - 6) + 1
endfunction

" vim: filetype=vim
