" put $HOME .dokuwiki_list
"
" お勉強メモ	http://www.live-emotion.com/wiki/	start	ryo	wqinbmxw

scriptencoding utf-8

command! DokuVim :call DokuWiki()

"-------------------------------------------------------------------------------
" wiki edit
function! DW_get_edit_page(site_name, url, page, user, password)
  " read wiki data
  let tmp = tempname()
  let cmd = "curl -s -o " . tmp 
  if a:user != ''
    let cmd .= ' -u ' . a:user . ":" . a:password
  endif
  let cmd .= ' "' . a:url . AL_urlencode(a:page) . '?do=edit"'

  let result = system(cmd)
  let result = AL_fileread(tmp)
  let result = iconv(result, 'utf-8', &enc)
  silent! exec "e! ++enc=utf-8 " . tmp

  " read date parameter
  let stmp = @/
  let @/ = '<input type="hidden" name="date" value="'
  silent! exec "normal! n"
  let @/ = stmp
  let date_line = getline('.')
  let date = substitute(date_line, '.*name="date" value="\(\d\{-}\)" />', '\1', '') 
  let msg = substitute(result, '.*<textarea\_.\{-}>.\(\_.\{-}\)</textarea>.*', '\1', '')

  let b:site_name = a:site_name
  let b:page = a:page
  let b:url = a:url
  let b:user = a:user
  let b:password = a:password
  let b:date = date

  normal! ggdG
  set paste

  silent! exec "normal! i[[トップ]] [[リロード]] [[一覧]]\n--------------------------------------------------------------------------------\n"
  exec "set ft=dokuwiki"
  exec "normal! i".msg
  let file = b:page . ' ' . b:site_name
  silent! exec "f " . escape(file, ' ')
  silent! set nomodified
  silent! setlocal noswapfile
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_move()<CR>
  nnoremap <silent> <buffer> <TAB>   :call <SID>DW_jump()<CR>

  call delete(tmp)

  augroup WikiEdit
    au! BufWriteCmd <buffer> call DW_write()
  augroup END
endfunction

function! DW_write()
  let conf = confirm("タイムスタンプを更新しますか？", "&Yes\n&No")
  if conf == 0 | return | endif

  silent! exec "normal! 1G2D"

  " url encode per line
	let cl = 1
	while cl <= line('$')
		let line = getline( cl )
		let line = iconv( line, &enc, 'utf-8' )
		let line = AL_urlencode( line )
		call setline( cl, line )
		let cl = cl + 1
	endwhile

  " url encode for LF
	if 1 < line('$')
		silent! %s/$/%0A/g
		execute ":noh"
		let @/ = ''
	endif

  let cmd = "normal! 1G0i" . "id=" . b:page
  let cmd .= "&rev="
  let cmd .= "&date=" . b:date
  let cmd .= "&prefix="
  let cmd .= "&suffix="
  let cmd .= "&do[save]="
  if (conf == 2)
    let cmd .= "&minor=1"
  endif
  let cmd .= "&wikitext="
  silent! exec cmd

  let post = tempname()
  let result = tempname()
  call AL_write(post)

  let cmd = "curl -s -o " . result . " -d @" . post
  if b:user != ''
    let cmd .= ' -u ' . b:user . ":" . b:password
  endif
  let cmd .= ' "' . b:url . 'doku.php"'

  call system(cmd)
  call delete (post)
  call delete (result)

  call DW_get_edit_page(b:site_name, b:url, b:page, b:user, b:password)
endfunction

function! s:DW_move()
  let line = getline('.')

  let col = col('.')
  let link = matchstr(getline('.'), '\%<'.(col+1).'c\[\[[^\[\]]\{-}\]\]\%>'.col.'c')
  let cur = substitute(link, '\[\[\(.*\)\]\]', '\1', '')

  if cur == '' | return | endif

  if line('.') < 3
    if cur == 'トップ'
      call DW_get_edit_page(b:site_name, b:url, 'start', b:user, b:password)
    endif
    if cur == 'リロード'
      call DW_get_edit_page(b:site_name, b:url, b:page, b:user, b:password)
    endif
    if cur == '一覧'
      call s:DW_get_list_page('?do=index')
    endif
    return
  endif

  if cur =~ '.*?idx=.*'
    let param = substitute(cur, '.*\(?idx=.*\)', '\1', '')
    call s:DW_get_list_page(param)
  else
    call DW_get_edit_page(b:site_name, b:url, cur, b:user, b:password)
  endif

endfunction

function! s:DW_jump()
  let tmp = @/
  let @/ = '\[\[[^\[\]]\{-}\]\]'
  silent! exec "normal! n"
  let @/ = tmp
endfunction

function! s:DW_get_list_page(param)
  " read index
  let tmp = tempname()
  let cmd = "curl -s -o " . tmp 
  if b:user != ''
    let cmd .= ' -u ' . b:user . ":" . b:password
  endif
  let cmd .= ' "' . b:url . b:page . a:param . '"'

  let result = system(cmd)
  let result = AL_fileread(tmp)
  let result = iconv(result, 'utf-8', &enc)

  let msg = substitute(result, '.\{-}<ul class="idx">.\(\_.\{-}\)</li></ul>.*', '\1', '')
  exec "normal! ggdG"
  let lines = split(msg, '\n')
  silent! exec "normal! i[[トップ]] [[リロード]] [[一覧]]\n--------------------------------------------------------------------------------\n"

  let level = 1
  for line in lines
    if line =~ '^<ul.*$'
      let level += 1
    endif

    if line =~ '^</ul.*$'
      let level -= 1
    endif

    if line =~ '.*<a href=".\{-}".*'
      let page = substitute(line, '.*<a href=".\+\/\(.\{-}\)".*', '\1', '')
      let page = AL_urldecode(page)
      let page = iconv(page, 'utf-8', &enc)
      if level > 1
        silent! exec "normal! " .(level * 2). "i "
      endif

      silent! exec "normal! a  * [[".page."]]\<CR>"
    endif
  endfor

  call delete(tmp)

endfunction

"-------------------------------------------------------------------------------
" wiki bookmark
function! DokuWiki()
  exec ":sp ~/.dokuwiki_list"
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_list_read()<CR>
endfunction

function! s:DW_list_read()
  let line = getline('.')
  if line !~ '^.*\thttp://'
    return
  endif

  let [site_name, url, page, user, password] = split(line, '\s\+')

	if &modified
		execute ":w"
	endif
  call DW_get_edit_page(site_name, url, page, user, password)

endfunction
