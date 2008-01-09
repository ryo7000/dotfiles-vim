function! s:is_symfony()
  let fname = fnamemodify(bufname("%"), ":p")
  if (fname =~ 'apps.*\.php$' && fname !~ 'templates')
	return 1
  end
endfunction

au BufNewFile,BufRead * if s:is_symfony() | set filetype=symfony | endif
