" �쥸�����������ϰϤ�diff
" 1. �ϰϤ�"�˥��
" 2. �ϰϤ�����V�⡼�ɤΤޤ�:DiffClip
command! -nargs=0 -range DiffClip <line1>, <line2>:call <SID>DiffClip('0')

"�쥸���� reg ��diff��Ȥ�
function! <SID>DiffClip(reg) range
	exe "let @a=@" . a:reg
	exe a:firstline  . "," . a:lastline . "y b"
	new
	" ���Υ�����ɥ����Ĥ�����Хåե���õ��褦�ˤ���
	set buftype=nofile bufhidden=wipe
	put a
	diffthis
	vnew
	set buftype=nofile bufhidden=wipe
	put b
	diffthis 
endfunction
