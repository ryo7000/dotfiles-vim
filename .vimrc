if !&compatible
  set nocompatible
endif

set encoding=utf-8

if has('vim_starting')
  filetype plugin indent off

  " Windowsで$HOME/vimfilesの代わりに、$VIM/.vimを使う
  if has('win32') || has('win64')
    let s:vim_home = $VIM

    " filetype onで、runtime! ftdetect/*.vimするので、
    " その前にruntimepathを設定
    " (filetype onは、syntax on/enableで読み込まれる$VIMRUNTIME/syntax/syntax.vimの中で実行される)
    set runtimepath=$VIM/.vim,$VIMRUNTIME,$VIM/.vim/after
  else
    let s:vim_home = $HOME
  endif

  let &runtimepath .= ',' . s:vim_home . '/.vim/dein/dein.vim/'
endif

let s:dein_dir = expand(s:vim_home . '/.vim/dein/')

" dein.vim {{{1
" git clone https://github.com/Shougo/dein.vim ~/.vim/dein/dein.vim

if dein#load_state(s:dein_dir)
  let s:toml      = s:dein_dir . '/dein.toml'
  let s:lazy_toml = s:dein_dir . '/dein_lazy.toml'

  call dein#begin(s:dein_dir, [s:toml, s:lazy_toml])

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if has('vim_starting')
  let g:vimproc#download_windows_dll = 1

  " install vimproc at first.
  if dein#check_install(['vimproc.vim'])
    call dein#install(['vimproc.vim'])
  endif

  if dein#check_install()
    call dein#install()
  endif
endif

"" $VIMRUNTIME/menu.vimを読みこまない
set guioptions&
set guioptions+=M
set guioptions-=T
set guioptions-=m

filetype plugin indent on

" python3 {{{1
if has('win32') || has('win64')
  set runtimepath+=$VIM
  set pythonthreedll=$VIM/python3/python35.dll
endif

" Encoding {{{1

" from kaoriya encoding_japan.vim & kana .vimrc
if !exists('did_encoding_settings') && has('iconv')
  let s:enc_eucjp = 'euc-jp'
  let s:enc_jisx = 'iso-2022-jp'

  " 利用しているiconvライブラリの性能を調べる。
  "
  " 比較的新しいJISX0213をサポートしているか検査する。euc-jisx0213が定義してい
  " る範囲の文字をcp932からeuc-jisx0213へ変換できるかどうかで判断する。
  "
  if iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_eucjp = 'euc-jisx0213,euc-jp'
    let s:enc_jisx = 'iso-2022-jp-3'
  endif

  let value = 'ucs-bom'
  if &encoding !=? 'utf-8'
    let value = value. ',ucs-2le,ucs-2'
  endif

  if &encoding ==? 'utf-8'
    " UTF-8環境向けにfileencodingsを設定する
    let value = value. ','.s:enc_jisx. ','.s:enc_eucjp. ',cp932'
  elseif &encoding ==? 'cp932'
    " CP932環境向けにfileencodingsを設定する
    let value = value. ','.s:enc_jisx. ',utf-8,'.s:enc_eucjp
  elseif &encoding ==? 'euc-jp' || &encoding ==? 'euc-jisx0213'
    " EUC-JP環境向けにfileencodingsを設定する
    let value = value. ','.s:enc_jisx. ',utf-8,cp932'
  endif
  if has('guess_encode')
    let value = 'guess,'.value
  endif
  let &fileencodings = value

  unlet s:enc_eucjp
  unlet s:enc_jisx

  let did_encoding_settings = 1
end

" Options {{{1
syntax enable

if !has("gui_running")
  if !exists('g:colors_name')
    colorscheme lucius
    set background=dark
    " for tmux + urxvt
    " via http://snk.tuxfamily.org/log/vim-256color-bce.html
    set t_ut=
  endif

  set t_Co=256

  " Termでmouseを使う設定
  set mouse=a
  set ttymouse=xterm2
endif

if has('win32') || has('win64')
  " for gf
  set isfname-=:
endif

if has('kaoriya')
  set ambiwidth=auto
else
  set ambiwidth=double
endif

set autoindent
set backspace=indent,eol,start
set cinoptions=g0,(0
set cmdheight=2
set formatoptions=tcqmM
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif if executable('jvgrep')
  set grepprg=jvgrep
endif
set history=100
set hlsearch
set incsearch
set list
set listchars=tab:>-,trail:-
set laststatus=2
set nobackup
set nowrapscan
set nrformats=hex
set shiftwidth=4
set shortmess& shortmess+=I
set showcmd
set showmatch
set statusline=%n:\ %<%f%=%y\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P 
set tabstop=4
set title
set titlestring=Vim:\ %f\ %h%r%m
set ruler
set wildmenu
set fileformat=unix
set expandtab

set ignorecase
set smartcase

if has('persistent_undo')
  let &undodir = s:vim_home . '/.vim/undo'
  set undofile
endif

" 親ディレクトリのtagsも検索
set tags& tags+=tags;

" cscope関連
map <silent> g<C-]> :cs find c <C-R>=expand("<cword>")<CR><CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-

" Mappings {{{1

nmap <C-n> :cn<CR>zz
nmap <C-p> :cp<CR>zz
nmap <C-j> :set list!<CR>
nmap <C-Enter> i<Enter><Esc>

" C-@でもEsc
noremap <C-@>  <Esc>
noremap! <C-@>  <Esc>

" i_Ctrl-Uをundoできるように
inoremap <C-U> <C-G>u<C-U>

" 日本語入力中にESCで、Nomalに戻る & 日本語入力を終了する
if has("kaoriya")
  imap <silent> <ESC> <ESC>:set iminsert=0<CR>
endif

" folding {{{2
" http://d.hatena.ne.jp/ns9tks/20080318/1205851539

" 行頭で h を押すと折畳を閉じる。
nnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zc' : 'h'
" 折畳上で l を押すと折畳を開く。
nnoremap <expr> l foldclosed(line('.')) != -1 ? 'zo0' : 'l'
" 行頭で h を押すと選択範囲に含まれる折畳を閉じる。
vnoremap <expr> h col('.') == 1 && foldlevel(line('.')) > 0 ? 'zcgv' : 'h'
" 折畳上で l を押すと選択範囲に含まれる折畳を開く。
vnoremap <expr> l foldclosed(line('.')) != -1 ? 'zogv0' : 'l'

" for urxvt {{{2
map <Esc>[27;5;9~ <C-tab>

" tab navigation like firefox {{{2
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
map <C-w>t :tabnew<cr>

" C-@でEsc
noremap <C-@> <Esc>
noremap! <C-@> <Esc>

" 検索語を画面の真ん中に {{{2
" *, #, g*, g#はカーソル移動を抑制
noremap n nzz
noremap N Nzz
noremap * *Nzz
noremap # #Nzz
noremap g* g*Nzz
noremap g# g#Nzz

" Plugins & Macros {{{1

" matchit
so $VIMRUNTIME/macros/matchit.vim

" lightline
let g:lightline = {
\ 'colorscheme': 'wombat',
\ 'active': {
\   'left':  [['mode', 'paste'], ['fugitive', 'filename']],
\   'right': [['lineinfo'], ['percent'],
\             ['fileformat', 'fileencoding', 'filetype'],
\             ['linter_errors', 'linter_warnings', 'linter_ok']]
\ },
\ 'component': {
\   'readonly': '%{&readonly?"\u2b64":""}',
\ },
\ 'component_function': {
\   'mode': 'lightline_component#mode',
\   'readonly': 'lightline_component#readonly',
\   'fugitive': 'lightline_component#fugitive',
\   'filename': 'lightline_component#filename',
\ },
\ 'component_expand': {
\   'linter_warnings': 'lightline#ale#warnings',
\   'linter_errors': 'lightline#ale#errors',
\   'linter_ok': 'lightline#ale#ok',
\ },
\ 'component_type': {
\   'linter_warnings': 'warning',
\   'linter_errors': 'error',
\   'linter_ok': 'left',
\ },
\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
\ }

" ale
let g:ale_linters = {
\   'javascript': ['eslint'],
\}
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%][%severity%]%[code]% %s '

" Simple Javascript Indenter
let g:SimpleJsIndenter_BriefMode = 1

" eregex
let g:eregex_default_enable = 0

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-better-whitespace
let g:better_whitespace_filetypes_blacklist = ['vimfiler', 'unite', 'diff']

" Denite {{{2

nnoremap    [denite]   <Nop>
nmap    <Space> [denite]
nmap <silent> <C-s> [denite]c
nnoremap <silent> [denite]c :Denite file buffer<CR>
nnoremap <silent> [denite]d :Denite directory_rec<CR>
nnoremap <silent> [denite]b :DeniteBufferDir file<CR>
nnoremap <silent> [denite]r :Denite file_rec/git<CR>
nnoremap <silent> [denite]n :Denite file_mru<CR>
nnoremap <silent> [denite]u :Denite buffer<CR>
nnoremap <silent> [denite]o :Denite unite:outline<CR>

call denite#custom#option('default', {
      \ 'highlight_matched_char': 'Identifier',
      \ 'cursor_wrap': v:true })

call denite#custom#map('insert', '<C-n>',
      \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>',
      \ '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-w>',
      \ '<denite:move_up_path>', 'noremap')

call denite#custom#action('directory', 'rec',
      \ {context -> denite#start([{'name': 'file_rec', 'args': [context['targets'][0]['word']]}])})
call denite#custom#map('insert', '<C-r>',
      \ '<denite:do_action:rec>', 'noremap')

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

" Unite {{{2

nnoremap    [unite]   <Nop>
nmap    <Tab> [unite]
nnoremap <silent> [unite]c :Unite -buffer-name=files file file/new buffer bookmark<CR>
nnoremap <silent> [unite]b :UniteWithBufferDir -buffer-name=files -prompt=%\  file file/new<CR>
nnoremap <silent> [unite]r :Unite -buffer-name=files file_rec/git<CR>
nnoremap <silent> [unite]n :Unite -buffer-name=files file_mru<CR>
nnoremap <silent> [unite]t :Unite tab<CR>
nnoremap <silent> [unite]u :Unite buffer<CR>
nnoremap <silent> [unite]k :Unite bookmark<CR>
nnoremap <silent> [unite]o :Unite outline<CR>
nnoremap <silent> [unite]g :Unite grep<CR>

let g:unite_enable_auto_select = 0

if has('win32') || has('win64')
  if executable(expand('$ProgramFiles/Git/usr/bin/find.exe'))
    let g:unite_source_rec_async_command = [expand('$ProgramFiles/Git/usr/bin/find.exe'), '-L']
  end
endif

call unite#custom#profile('default', 'context', {
    \ 'prompt' : '> ',
    \ 'start_insert' : 1
\ })

" replace buffer dir
call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/"', 2)

" replace current dir
call unite#custom#substitute('files', '^@', '\=getcwd()."/"', 1)

" replace .vim dir
call unite#custom#profile('files', 'substitute_patterns', {
      \ 'pattern' : '^\.v/',
      \ 'subst' : [expand('~/.vim/'),
      \   unite#util#substitute_path_separator($HOME)
      \       . '/.bundle/*/'],
      \ 'priority' : 1000,
      \ })

" fuzzy match and sort
call unite#custom#source('file,file/new', 'matchers', ['matcher_hide_hidden_files', 'matcher_fuzzy'])
call unite#custom#source('buffer,file_mru', 'matchers', 'matcher_fuzzy')
call unite#custom#source('file,file/new,buffer', 'sorters',  'sorter_rank')

" Unite file中はsmartcase無視
call unite#custom#profile('action', 'context', {
\   'smartcase' : 0
\ })

autocmd FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
  nnoremap <silent><buffer><expr> l
          \ unite#smart_map('l', unite#do_action('default'))

  " Runs "split" action by <C-s>.
  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
  imap <silent><buffer><expr> <C-r>     unite#do_action('rec/async')
endfunction

" neocomplete {{{2
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" for java
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.java = '\h\w\{2,\}\|[^. \t]\.\%(\h\w\+\)\?'

" neosnippet {{{2
" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

let g:neosnippet#snippets_directory = s:vim_home . '/.vim/snippets'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" VimFiler {{{2
let g:vimfiler_as_default_explorer = 1

" QuickRun {{{2

let g:quickrun_config = {
\  "_" : {
\      "runner" : "vimproc",
\      "runner/vimproc/updatetime" : 60,
\      "outputter" : "error",
\      "outputter/error/success" : "buffer",
\      "outputter/error/error" : "quickfix"
\ },
\}

" DirDiff {{{2

let g:DirDiffExcludes = ".svn"

" vim-ruby (rubycomplete.vim) {{{2
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_classes_in_global = 1

" omnisharp with roslyn {{{2
" download and expand https://github.com/OmniSharp/omnisharp-roslyn/releases

if has('win32') || has('win64')
  let g:OmniSharp_server_type = 'roslyn'
  let g:OmniSharp_server_path = $VIM . '\omnisharp\OmniSharp.exe'
endif

" tagbar
let g:tagbar_left = 1
nmap <C-w><C-t> :TagbarToggle<cr>

" Etc {{{1

let g:mapleader = "\<C-k>"

" ファイルを開いた時にファイル内の最後の記憶している位置にジャンプ
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" rails.vim
com! -bar -nargs=1 OpenURL call OpenNewTab("<args>")

" 全角文字と半角文字の間にスペースを入れる
" via http://vimwiki.net/?tips/54
com! -nargs=0 EnterSpace s/\%(\([^\t -~]\)\%([!#-~]\)\@=\|\([!#-~]\)\%([^\t -~]\)\@=\)/\1\2 /g

" closetag
let g:closetag_html_style=1
augroup CloseTagMacro
  au!
  au Filetype html,xml,xsl,ant,tpl,php,eruby ru macros/closetag.vim
augroup END

" Show EOL WhiteSpace
autocmd BufEnter *.c,*.cpp,*.rb match ErrorMsg /\s\+$/

" kaoriya cmdex.vimより {{{2
" :CdCurrent
"   Change current directory to current file's one.
command! -nargs=0 CdCurrent cd %:p:h

" :Scratch
"   Open a scratch (no file) buffer.
"   閉じてしまっても:ls!で見つかる
command! -nargs=0 Scratch new | setlocal bt=nofile noswf | let b:cmdex_scratch = 1
function! s:CheckScratchWritten()
  if &buftype ==# 'nofile' && expand('%').'x' !=# 'x' && exists('b:cmdex_scratch') && b:cmdex_scratch == 1
    setlocal buftype= swapfile
    unlet b:cmdex_scratch
  endif
endfunction
augroup CmdexScratch
autocmd!
autocmd BufWritePost * call <SID>CheckScratchWritten()
augroup END

" c_CTRL-X
"   Input current buffer's directory on command line.
cnoremap <C-X> <C-R>=<SID>GetBufferDirectory()<CR>/
function! s:GetBufferDirectory()
  let path = expand('%:p:h')
  let cwd = getcwd()
  if match(path, cwd) != 0
    return path
  elseif strlen(path) > strlen(cwd)
    return strpart(path, strlen(cwd) + 1)
  else
    return '.'
  endif
endfunction

" source pc-local vimrc
let s:localrc = s:vim_home . '/.vimrc.local'
if filereadable(s:localrc)
  source `=s:localrc`
end

" vim: et sts=2 sw=2 fdm=marker fdc=3
