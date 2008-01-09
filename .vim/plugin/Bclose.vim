" ウィンドウを閉じずにバッファを閉じる

function! <SID>BufcloseCloseIt()
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")

	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif

	if bufnr("%") == l:currentBufNum
		new
	endif

	if buflisted(l:currentBufNum)
		execute("bwipeout ".l:currentBufNum)
	endif

endfunction

command! Bclose call <SID>BufcloseCloseIt()
