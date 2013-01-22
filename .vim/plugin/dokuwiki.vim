" vim:set fdm=marker:
" put $HOME .dokuwiki_list
"
" お勉強メモ	http://www.live-emotion.com/wiki/	start

scriptencoding utf-8

command! DokuVim :call DokuWiki()

let s:curl_cmd = 'curl --silent'

"-------------------------------------------------------------------------------
" wiki edit
function! DW_get_edit_page(site_name, page) " {{{
  " read wiki editpage data
  let tmp = tempname()
  let cmd = s:curl_cmd . " -o " . tmp 
            \ . ' -b ' . s:site_info[a:site_name].cookie
            \ . ' "' . s:site_info[a:site_name].url . s:Urlencode(iconv(a:page, &enc, 'utf-8')) . '?do=edit"'

  let result = system(cmd)
  let result = join(readfile(tmp), "\n")
  let result = iconv(result, 'utf-8', &enc)

  let date = substitute(result, '.*name="date" value="\(\d\{-}\)".*', '\1', '') 
  let msg = substitute(result, '.*<textarea\_.\{-}>.\(\_.\{-}\)</textarea>.*', '\1', '')
  let msg = s:DecodeEntityreference(msg)

  enew
  let b:site_name = a:site_name
  let b:page = a:page
  let b:date = date

  " create page
  setlocal indentexpr=
  setlocal noai

  silent! exec "normal! iPage: [[".b:page."]]\n"
  silent! exec "normal! i[[トップ]] [[リロード]] [[新規]] [[一覧]]\n--------------------------------------------------------------------------------\n"
  set ft=dokuwiki
  exec "normal! i".msg
  let file = b:site_name . " [" . b:page . "]"
  silent! exec "f " . escape(file, ' ')
  silent! set nomodified
  "silent! setlocal buftype=nofile "FIXME nofileだとBufWriteCmdはでてこない
  silent! setlocal bufhidden=hide
  silent! setlocal noswapfile
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_move()<CR>
  nnoremap <silent> <buffer> <TAB>   :call <SID>DW_jump(0)<CR>
  nnoremap <silent> <buffer> <S-TAB>   :call <SID>DW_jump(1)<CR>

  call delete(tmp)

  augroup WikiEdit
    au! BufWriteCmd <buffer> call s:DW_write()
  augroup END
endfunction " }}}

function! s:DW_write() " {{{
  let conf = confirm("タイムスタンプを更新しますか？", "&Yes\n&No")
  if conf == 0 | return | endif

  let post = []
  let line = "id=" . iconv(b:page, &enc, 'utf-8')
             \ . "&rev="
             \ . "&date=" . b:date
             \ . "&prefix="
             \ . "&suffix="
             \ . "&do[save]="
  if (conf == 2)
    let line .= "&minor=1"
  endif
  let line .= "&wikitext="
  let post = add(post, line)

  " url encode per line
	let cl = 4
	while cl <= line('$')
		let line = getline( cl )
		let line = iconv( line, &enc, 'utf-8' )
		let line = s:Urlencode( line )
    let line = substitute(line, '$', '%0A', 'g')
    let post = add(post, line)
		let cl = cl + 1
	endwhile

  let postfile = tempname()
  let result = tempname()
  call writefile(post, postfile)

  let cmd = s:curl_cmd . " -o " . result . " -d @" . postfile
            \ . ' -b ' . s:site_info[b:site_name].cookie
            \ . ' "' . s:site_info[b:site_name].url . 'doku.php"'

  call system(cmd)
  call delete (postfile)
  call delete (result)

  " start indexer
  let cmd = s:curl_cmd . ' -b ' . s:site_info[b:site_name].cookie
            \ . ' ' . s:site_info[b:site_name].url . 'lib/exe/indexer.php?'
            \ . 'id='. b:page
            \ . '&amp;' . b:date
  call system(cmd)
  silent! set nomodified
endfunction " }}}

function! s:DW_move() " {{{
  let line = getline('.')

  let col = col('.')
  let link = matchstr(getline('.'), '\%<'.(col+1).'c\[\[[^\[\]]\{-}\]\]\%>'.col.'c')
  let cur = substitute(link, '\[\[\(.*\)\]\]', '\1', '')

  if cur == '' | return | endif

  if line('.') < 4
    if cur == 'トップ'
      call DW_get_edit_page(b:site_name, 'start')
    endif
    if cur == 'リロード'
      call DW_get_edit_page(b:site_name, b:page')
    endif
    if cur == '新規'
      call DW_get_edit_page(b:site_name, input('新規ページ名: '))
    endif
    if cur == '一覧'
      call s:DW_get_list_page(b:site_name, '?do=index')
    endif
    return
  endif

  if cur =~ '.*?idx=.*'
    let param = substitute(cur, '.*\(?idx=.*\)', '\1', '')
    call s:DW_get_list_page(b:site_name, param)
  else
    call DW_get_edit_page(b:site_name, cur)
  endif

endfunction " }}}

function! s:DW_jump(flag) " {{{
  let tmp = @/
  let @/ = '\[\[[^\[\]]\{-}\]\]'
  silent! exec "normal! " . (a:flag == 0 ? "n" : "N")
  let @/ = tmp
endfunction " }}}

function! s:DW_get_list_page(site_name, param) " {{{
  " read index
  let tmp = tempname()
  let cmd = s:curl_cmd . " -o " . tmp 
            \ . ' -b ' . s:site_info[a:site_name].cookie
            \ . ' "' . s:site_info[a:site_name].url . a:param . '"'

  let result = system(cmd)
  let result = join(readfile(tmp), "\n")
  let result = iconv(result, 'utf-8', &enc)

  let msg = substitute(result, '.\{-}<\/div>\n\n<ul class="idx">.\(\_.\{-}\)</li></ul>.*', '\1', '')
  enew
  let b:site_name = a:site_name

  let lines = split(msg, '\n')
  silent! exec "normal! iPage: [[一覧]]\n"
  silent! exec "normal! i[[トップ]] [[リロード]] [[新規]] [[一覧]]\n--------------------------------------------------------------------------------\n"

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
      let page = Urldecode(page)
      let page = iconv(page, 'utf-8', &enc)
      if level > 1
        silent! exec "normal! " .(level * 2). "i "
      endif

      silent! exec "normal! a  * [[".page."]]\<CR>"
    endif
  endfor

  set ft=dokuwiki
  silent! set nomodified
  silent! setlocal buftype=nofile
  silent! setlocal bufhidden=hide
  silent! setlocal noswapfile
  let file = a:site_name . " [一覧]"
  silent! exec "f " . escape(file, ' ')
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_move()<CR>
  nnoremap <silent> <buffer> <TAB>   :call <SID>DW_jump(0)<CR>
  nnoremap <silent> <buffer> <S-TAB>   :call <SID>DW_jump(1)<CR>

  call delete(tmp)

endfunction " }}}

function! s:DW_list_read() " {{{
  let line = getline('.')
  if line !~ '^.*\thttp://'
    return
  endif

  let [site_name, url, page] = split(line, '\s\+')

	if &modified
		execute "w"
	endif
  let cookie_file = s:DW_Login(site_name, url, page)

  if len(cookie_file)
    let s:site_info[site_name] = { 'url' : url, 'cookie' : cookie_file }
    call DW_get_edit_page(site_name, page)
  endif
endfunction " }}}

function! s:DW_Login(site_name, url, page) " {{{
  let user = input('ユーザー名: ')
  let password = inputsecret('パスワード: ')
  let cookie_file = tempname()

  let cmd  = s:curl_cmd . ' ' . a:url . 'doku.php'
             \ . ' -d do = login -d'
             \ . ' -d id=' . a:page  . ' -d u=' . user . ' -d p=' . password
             \ . ' -c ' . cookie_file

  let result = system(cmd)

  if result !~ '<div class="error">'
    echo 'ログインしました'
    return cookie_file
  else
    echohl Error | echo 'ログイン失敗しました' | echohl None
    call delete(cookie_file)
    return
  endif
endfunction " }}}

function! DokuWiki() " {{{
  if !exists("*s:site_info")
    let s:site_info = {}
  endif

  exec ":sp ~/.dokuwiki_list"
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_list_read()<CR>
endfunction " }}}

function! s:DecodeEntityreference(str) " {{{
  let str = a:str
  let str = substitute(str, '&gt;', '>', 'g')
  let str = substitute(str, '&lt;', '<', 'g')
  let str = substitute(str, '&quot;', '"', 'g')
  let str = substitute(str, '&apos;', "'", 'g')
  let str = substitute(str, '&amp;', '\&', 'g')
  return str
endfunction " }}}

function! s:Urlencode(str) " {{{
  let r = a:str
  let r = substitute(r, '[^ a-zA-Z0-9_.-]', '\=s:Char2hex(submatch(0))', 'g')
  let r = substitute(r, ' ', '+', 'g')
  return r
endfunction " }}}

function! s:Urldecode(str) " {{{
  let retval = a:str
  let retval = substitute(retval, '+', ' ', 'g')
  let retval = substitute(retval, '%\(\x\x\)', '\=nr2char("0x".submatch(1))', 'g')
  return retval
endfunction " }}}

function! s:Char2hex(c) " {{{
  let n = char2nr(a:c)
  let r = ''

  while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile

  let r = substitute(r, '..', '%\0', 'g')
  return r
endfunction " }}}
