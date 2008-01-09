function! s:is_symtmpl()
  let fname = fnamemodify(bufname("%"), ":p")
  if (fname =~ '.*templates.*\.php$')
	return 1
  end
endfunction

au BufNewFile,BufRead * if s:is_symtmpl() | set filetype=symtmpl | endif
