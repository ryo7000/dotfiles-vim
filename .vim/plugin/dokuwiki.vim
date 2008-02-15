" vim:set fdm=marker:
" put $HOME .dokuwiki_list
"
" お勉強メモ	http://www.live-emotion.com/wiki/	start

scriptencoding utf-8

command! DokuVim :call DokuWiki()

let s:curl_cmd = 'curl --silent'

"-------------------------------------------------------------------------------
" wiki edit
function! DW_get_edit_page(info) " {{{
  " read wiki editpage data
  let tmp = tempname()
  let cmd = s:curl_cmd . " -o " . tmp 
            \ . ' -b ' . a:info['cookie_file']
            \ . ' "' . a:info['url'] . s:Urlencode(a:info['page']) . '?do=edit"'

  let result = system(cmd)
  let result = join(readfile(tmp), "\n")
  let result = iconv(result, 'utf-8', &enc)

  let date = substitute(result, '.*name="date" value="\(\d\{-}\)".*', '\1', '') 
  let msg = substitute(result, '.*<textarea\_.\{-}>.\(\_.\{-}\)</textarea>.*', '\1', '')
  let msg = s:decode_entityreference(msg)

  enew
  let b:info = a:info
  let b:info['date'] = date

  " create page
  setlocal indentexpr=
  setlocal noai

  silent! exec "normal! iPage: [[".b:info['page']."]]\n"
  silent! exec "normal! i[[トップ]] [[リロード]] [[新規]] [[一覧]]\n--------------------------------------------------------------------------------\n"
  set ft=dokuwiki
  exec "normal! i".msg
  let file = b:info['page'] . " : " . b:info['site_name']
  silent! exec "f " . escape(file, ' ')
  silent! set nomodified
  silent! setlocal noswapfile
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_move()<CR>
  nnoremap <silent> <buffer> <TAB>   :call <SID>DW_jump()<CR>

  call delete(tmp)

  augroup WikiEdit
    au! BufWriteCmd <buffer> call s:DW_write()
  augroup END
endfunction " }}}

function! s:DW_write() " {{{
  let conf = confirm("タイムスタンプを更新しますか？", "&Yes\n&No")
  if conf == 0 | return | endif

  silent! exec "normal! 1G2D"

  " url encode per line
	let cl = 1
	while cl <= line('$')
		let line = getline( cl )
		let line = iconv( line, &enc, 'utf-8' )
		let line = s:Urlencode( line )
		call setline( cl, line )
		let cl = cl + 1
	endwhile

  " url encode for LF
	if 1 < line('$')
		silent! %s/$/%0A/g
		execute ":noh"
		let @/ = ''
	endif

  let cmd = "normal! 1G0i" . "id=" . b:info['page']
  let cmd .= "&rev="
  let cmd .= "&date=" . b:info['date']
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

  let cmd = s:curl_cmd . " -o " . result . " -d @" . post
  if b:info['user'] != ''
    let cmd .= ' -u ' . b:info['user'] . ":" . b:info['password']
  endif
  let cmd .= ' "' . b:info['url'] . 'doku.php"'

  call system(cmd)
  call delete (post)
  call delete (result)

  " start indexer
  let cmd = s:curl_cmd . b:info['url'] . 'lib/exe/indexer.php?'
            \ 'id='. b:info['page']
            \ '&amp;' . b:info['date']
  call system(cmd)

  call DW_get_edit_page(b:info)
endfunction " }}}

function! s:DW_move() " {{{
  let line = getline('.')

  let col = col('.')
  let link = matchstr(getline('.'), '\%<'.(col+1).'c\[\[[^\[\]]\{-}\]\]\%>'.col.'c')
  let cur = substitute(link, '\[\[\(.*\)\]\]', '\1', '')

  if cur == '' | return | endif

  if line('.') < 4
    if cur == 'トップ'
      let b:info['page'] = 'start'
      call DW_get_edit_page(b:info)
    endif
    if cur == 'リロード'
      call DW_get_edit_page(b:info)
    endif
    if cur == '新規'
      let b:info['page'] = input('新規ページ名: ')
      call DW_get_edit_page(b:info)
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
    let b:info['page'] = cur
    call DW_get_edit_page(b:info)
  endif

endfunction " }}}

function! s:DW_jump() " {{{
  let tmp = @/
  let @/ = '\[\[[^\[\]]\{-}\]\]'
  silent! exec "normal! n"
  let @/ = tmp
endfunction " }}}

function! s:DW_get_list_page(param) " {{{
  " read index
  let tmp = tempname()
  let cmd = s:curl_cmd . " -o " . tmp 
            \ . ' -b ' . b:info['cookie_file']
            \ . ' "' . b:info['url'] . b:info['page'] . a:param . '"'

  let result = system(cmd)
  let result = AL_fileread(tmp)
  let result = iconv(result, 'utf-8', &enc)

  let msg = substitute(result, '.\{-}<ul class="idx">.\(\_.\{-}\)</li></ul>.*', '\1', '')
  "exec "normal! ggdG"
  enew
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
      let page = AL_urldecode(page)
      let page = iconv(page, 'utf-8', &enc)
      if level > 1
        silent! exec "normal! " .(level * 2). "i "
      endif

      silent! exec "normal! a  * [[".page."]]\<CR>"
    endif
  endfor

  call delete(tmp)

endfunction " }}}

function! s:decode_entityreference(str) " {{{
  let str = a:str
  let str = substitute(str, '&gt;', '>', 'g')
  let str = substitute(str, '&lt;', '<', 'g')
  let str = substitute(str, '&quot;', '"', 'g')
  let str = substitute(str, '&apos;', "'", 'g')
  let str = substitute(str, '&amp;', '\&', 'g')
  return str
endfunction " }}}

function! DokuWiki() " {{{
  exec ":sp ~/.dokuwiki_list"
  nnoremap <silent> <buffer> <CR>    :call <SID>DW_list_read()<CR>
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
  let info = s:DW_Login(site_name, url, page)

  if len(info)
    call DW_get_edit_page(info)
  endif
endfunction " }}}

function! s:DW_Login(site_name, url, page) " {{{
  let user = input('ユーザー名 : ')
  let password = inputsecret('パスワード: ')
  let cookie_file = tempname()

  let cmd  = s:curl_cmd . ' ' . a:url . 'doku.php'
             \ . ' -d do = login -d'
             \ . ' -d id=' . a:page  . ' -d u=' . user . ' -d p=' . password
             \ . ' -c ' . cookie_file

  let result = system(cmd)

  if result !~ '<div class="error">'
    echo 'ログインしました'
    return {'site_name' : a:site_name, 'url' : a:url, 'page' : a:page, 'cookie_file' : cookie_file }
  else
    echohl Error | echo 'ログイン失敗しました' | echohl None
    call delete(cookie_file)
    return {}
  endif
endfunction " }}}

function! s:Urlencode(str) " {{{
  let r = a:str
	let r = substitute(r, '[^ a-zA-Z0-9_.-]', '\=Char2hex(submatch(0))', 'g')
  let r = substitute(r, ' ', '+', 'g')
  return r
endfunction " }}}

function! s:Char2hex(c) " {{{
  let n = char2nr(a:c)
  let r = ''

  while n
		let r = '0123456789ABCDEF'[n % 16] . r
		let n = n / 16
	endwhile

  let r = '%'.(strlen(r) < 2 ? '0' : '').r
  return r
endfunction " }}}

" s:siteinfo['site_name'] = { 'url', 'cookie_file' }
" b:page = 'pagename'
" b:date = date
