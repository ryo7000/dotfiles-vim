function! s:is_dokuwiki()
	if match(getline(1,5), '^ \=\(=\{6}\)[^=]\+\1 *$') >= 0
		return 1
	endif
endfunction

au BufNewFile,BufRead * if s:is_dokuwiki() | set filetype=dokuwiki | endif
