function! lightline_component#mode()
  return winwidth(0) > 60 ? lightline#mode() : ''
endfunction

function! lightline_component#modified()
  return &ft =~ 'help\|vimfiler' ? '' : &modified ? '+' : &modifiable ? '' : '-'
endfunction

function! lightline_component#fugitive()
  if &ft !~? 'vimfiler' && exists("*fugitive#head")
    let _ = fugitive#head()
    return strlen(_) ? "\u2b60 "._ : ''
  endif
  return ''
endfunction

function! lightline_component#readonly()
  return &ft !~? 'help\|vimfiler' && &readonly ? "\u2b64" : ''
endfunction

function! lightline_component#filename()
  return ('' != lightline_component#readonly() ? lightline_component#readonly() . ' ' : '') .
        \ (&ft == 'vimfiler' ? vimfiler#get_status_string() : 
        \  &ft == 'unite' ? unite#get_status_string() : 
        \  &ft == 'vimshell' ? vimshell#get_status_string() :
        \  &ft == 'qf' ? '[qf] '. w:quickfix_title :
        \ '' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != lightline_component#modified() ? ' ' . lightline_component#modified() : '')
endfunction