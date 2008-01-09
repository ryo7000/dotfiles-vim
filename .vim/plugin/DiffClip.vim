" レジスタと選択範囲のdiff
" 1. 範囲を"にヤンク
" 2. 範囲を選択、Vモードのまま:DiffClip
command! -nargs=0 -range DiffClip <line1>, <line2>:call <SID>DiffClip('0')

"レジスタ reg とdiffをとる
function! <SID>DiffClip(reg) range
	exe "let @a=@" . a:reg
	exe a:firstline  . "," . a:lastline . "y b"
	new
	" このウィンドウを閉じたらバッファを消去するようにする
	set buftype=nofile bufhidden=wipe
	put a
	diffthis
	vnew
	set buftype=nofile bufhidden=wipe
	put b
	diffthis 
endfunction
