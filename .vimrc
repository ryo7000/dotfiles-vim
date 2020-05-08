if !&compatible
  set nocompatible
endif

set encoding=utf-8

if has('vim_starting')
  filetype plugin indent off

  " Windowsで$HOME/vimfilesの代わりに、$VIM/.vimを使う
  if has('win32') || has('win64')
    let g:vim_home = $VIM

    " filetype onで、runtime! ftdetect/*.vimするので、
    " その前にruntimepathを設定
    " (filetype onは、syntax on/enableで読み込まれる$VIMRUNTIME/syntax/syntax.vimの中で実行される)
    set runtimepath=$VIM/.vim,$VIMRUNTIME,$VIM/.vim/after
  else
    let g:vim_home = $HOME
  endif
endif

" dein.vim {{{1
execute('source ' . g:vim_home . '/.vim/dein/dein.conf.vim')

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

"" $VIMRUNTIME/menu.vimを読みこまない
set guioptions+=M
set guioptions-=T
set guioptions-=m

filetype plugin indent on
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
  set grepprg=rg\ --vimgrep\ --sort\ path\ -M\ 200\ --max-columns-preview
  set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable('jvgrep')
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
  let &undodir = g:vim_home . '/.vim/undo'
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

" ins-completion-menu 表示中にcrで候補を決定して終了させる
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<cr>"

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
\ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2" },
\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3" },
\ }

" Simple Javascript Indenter
let g:SimpleJsIndenter_BriefMode = 1

" eregex
let g:eregex_default_enable = 0

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" vim-better-whitespace
let g:better_whitespace_filetypes_blacklist = ['diff']

" Denite {{{2

nnoremap    [denite]   <Nop>
nmap    <Space> [denite]
nmap <silent> <C-s> [denite]c
nnoremap <silent> [denite]c :Denite file buffer<CR>
nnoremap <silent> [denite]d :Denite directory_rec<CR>
nnoremap <silent> [denite]b :DeniteBufferDir file<CR>
nnoremap <silent> [denite]r :Denite -start-filter file/rec<CR>
nnoremap <silent> [denite]n :Denite -start-filter file_mru<CR>
nnoremap <silent> [denite]u :Denite buffer<CR>
nnoremap <silent> [denite]o :Denite unite:outline<CR>

autocmd FileType denite call s:denite_settings()
function! s:denite_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_settings()
function! s:denite_filter_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
endfunction

call denite#custom#option('_', #{
  \ max_dynamic_update_candidates: 50000,
  \ highlight_matched_char: 'Identifier'})

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm'])

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

let g:neosnippet#snippets_directory = g:vim_home . '/.vim/snippets'

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" QuickRun {{{2

let g:quickrun_config = {
\  "_" : {
\      "runner" : "vimproc",
\      "runner/vimproc/updatetime" : 60,
\      "outputter" : "error",
\      "outputter/error/success" : "buffer",
\      "outputter/error/error" : "quickfix"
\ },
\ 'cpp': {
\   'cmdopt': '-std=c++11',
\ },
\}

" DirDiff {{{2

let g:DirDiffExcludes = ".svn"

" vim-ruby (rubycomplete.vim) {{{2
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_classes_in_global = 1

" ALE {{{2
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = 'ALE: [%linter%][%severity%]%[code]% %s '
let g:ale_disable_lsp = 1
let g:ale_linters_explicit = 1
let g:ale_fixers = {
\  'javascript': ['prettier', 'eslint'],
\  'typescript': ['prettier'],
\  'vue': ['vls'],
\}

let g:ale_linters = {
\   'html': ['htmlhint'],
\   'javascript': ['eslint'],
\   'vue': ['vls'],
\   'c': ['clangtidy'],
\   'cpp': ['clangtidy'],
\}

" ALE C/C++ {{{3
" for handling c++ header with clang-tidy
let g:ale_c_parse_compile_commands = 1
" for clang-tidy to recognize .h file as c++ header
let g:ale_cpp_clangtidy_options = '-x c++'

" omnisharp with roslyn {{{2
" download and expand https://github.com/OmniSharp/omnisharp-roslyn/releases

let g:OmniSharp_server_type = 'roslyn'
if has('win32') || has('win64')
  let g:OmniSharp_server_path = $VIM . '\omnisharp\OmniSharp.exe'
else
  let g:OmniSharp_server_path = $HOME . '/.vim/omnisharp/run'
endif
let g:Omnisharp_start_server = 0

" tagbar
let g:tagbar_left = 1
nmap <C-w><C-t> :TagbarToggle<cr>

" gist vim
let g:gist_post_private = 1

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
cnoremap <C-X> <C-R>=<SID>GetBufferDirectory()<CR>
function! s:GetBufferDirectory()
  return fnamemodify(expand("%"), ":.:h") . (exists('+shellslash') && !&shellslash ? '\' : '/')
endfunction

" source directory local vimrc {{{2
augroup vimrc-local
  autocmd!
  autocmd BufNewFile,BufReadPost * call s:vimrc_local(expand('<afile>:p:h'))
augroup END

function! s:vimrc_local(loc)
  let files = findfile('.vimrc.local', escape(a:loc, ' ') . ';', -1)
  for i in reverse(filter(files, 'filereadable(v:val)'))
    source `=i`
  endfor
endfunction

" vim: et sts=2 sw=2 fdm=marker fdc=3
