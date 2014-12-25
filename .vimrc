if has('vim_starting')
  filetype plugin indent off
  set nocompatible

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

  let &runtimepath .= ',' . s:vim_home . '/.vim/bundle/neobundle.vim/'
endif

call neobundle#begin(expand(s:vim_home . '/.vim/bundle/'))

" NeoBundle {{{1
" git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
NeoBundleFetch 'Shougo/neobundle.vim'

NeoBundle 'vim-jp/vimdoc-ja'
NeoBundle 'kana/vim-fakeclip', '0.3.0'
NeoBundle 'Shougo/unite.vim', {'rev': 'ver.6.0'}
NeoBundle 'Shougo/neocomplete'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/neosnippet-snippets'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'Shougo/unite-outline', {'depends': 'Shougo/unite.vim'}
NeoBundle 'Shougo/neomru.vim', {'depends': 'Shougo/unite.vim'}
NeoBundle 'thinca/vim-ref', {'rev': 'unite-ref-v0.1.1'}
NeoBundle 'itchyny/lightline.vim'
NeoBundle 'majutsushi/tagbar', {'rev': 'v2.6.1'}
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'tpope/vim-surround'
NeoBundle 'http://repo.or.cz/r/vcscommand.git', {'rev': 'v1.99.46'}
NeoBundle 'thinca/vim-quickrun'
NeoBundle 'leafgarland/typescript-vim'
"NeoBundle 'othree/eregex.vim'
NeoBundle 'renamer.vim'
NeoBundle 'Align'
NeoBundle 'plasticboy/vim-markdown'
NeoBundle 'kannokanno/previm'
NeoBundle 'tyru/open-browser.vim'
NeoBundle 'nsf/gocode', {'rtp': 'vim/'}

if has('unix')
  " kaoriya vim bundled vimproc dll
  NeoBundle 'Shougo/vimproc', {
    \ 'build' : {
    \     'unix' : 'make -f make_unix.mak'
    \   },
    \ }
end

NeoBundleLazy 'lilydjwg/colorizer', {
  \ 'autoload' : { 'commands' : ['ColorToggle', 'ColorHighlight', 'ColorClear'] } }

" Colorscheme
NeoBundle 'jonathanfilip/vim-lucius'

NeoBundleLazy 'mattn/zencoding-vim', {
  \ 'autoload' : { 'filetypes' : ['css', 'haml', 'html', 'sass', 'scss', 'slim'] } }
" Ruby
NeoBundleLazy 'vim-ruby/vim-ruby', {
  \ 'autoload' : { 'filetypes' : ['ruby', 'eruby'] } }
NeoBundleLazy 'slim-template/vim-slim', {
  \ 'autoload' : { 'filetypes' : ['slim'] } }
" Rails
NeoBundleLazy 'tpope/vim-rails', {
  \ 'autoload' : { 'filetypes' : ['ruby', 'eruby'], 'rev': 'v4.4'} }
NeoBundleLazy 'ujihisa/unite-rake', { 'depends' : 'Shougo/unite.vim' }
NeoBundleLazy 'basyura/unite-rails', { 'depends' : 'Shougo/unite.vim' }

let s:bundle_rails = "unite-rake unite-rails"
function! s:bundleLoadDepends(bundle_names)
  execute 'NeoBundleSource '.a:bundle_names
  au! RailsLazyPlugins
endfunction
aug RailsLazyPlugins
  au User Rails call <SID>bundleLoadDepends(s:bundle_rails)
aug END

" Javascript
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', {
  \ 'autoload' : { 'filetypes' : ['javascript'] } }

call neobundle#end()

"" $VIMRUNTIME/menu.vimを読みこまない
set guioptions&
set guioptions+=M
set guioptions-=T
set guioptions-=m

filetype plugin indent on

" Encoding {{{1

set encoding=utf-8

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
if executable('jvgrep')
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
\   'left': [ ['mode', 'paste'], ['fugitive', 'filename'] ]
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
\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
\ }

" Simple Javascript Indenter
let g:SimpleJsIndenter_BriefMode = 1

" eregex
let g:eregex_default_enable = 0

" vim-markdown
let g:vim_markdown_folding_disabled = 1

" Unite {{{2

let g:unite_enable_start_insert = 1

nnoremap    [unite]   <Nop>
nmap    <Space> [unite]
nmap <silent> <C-s> [unite]c
nnoremap <silent> [unite]c :UniteWithCurrentDir -buffer-name=files file tab buffer file/new bookmark<CR>
nnoremap <silent> [unite]b :UniteWithBufferDir -buffer-name=files -prompt=%\  file file/new<CR>
nnoremap <silent> [unite]n :Unite -buffer-name=files file_mru<CR>
nnoremap <silent> [unite]o :Unite outline<CR>
nnoremap <silent> [unite]g :Unite grep<CR>
nnoremap <silent> [unite]r :UniteResume<CR>

" replace buffer dir
call unite#custom#substitute('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/"', 2)

" replace current dir
call unite#custom#substitute('files', '^@', '\=getcwd()."/"', 1)

" replace home dir
call unite#custom#substitute('files', '^\\', '~/')

" replace .vim dir
call unite#custom#substitute('files', '^;v', '~/.vim/')

" fuzzy match and sort
call unite#custom_source('file,file/new,buffer,file_mru', 'matchers', 'matcher_fuzzy')
call unite#custom_source('file,file/new,buffer,file_mru', 'sorters',  'sorter_rank')

" Unite file中はsmartcase無視
call unite#set_profile('files', 'smartcase', 0)


" neocomplete {{{2
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" for eclim & java
if !exists('g:neocomplete#force_omni_input_patterns')
  let g:neocomplete#force_omni_input_patterns = {}
endif
let g:neocomplete#force_omni_input_patterns.java = '\%(\h\w*\|)\)\.\w*'

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

" tagbar
let g:tagbar_left = 1
nmap <C-w><C-t> :TagbarToggle<cr>


" eclim {{{2
let g:EclimCompletionMethod = 'omnifunc'

" quickfixが多いとgetqflist()が遅い
" CursorMoved
let g:EclimShowCurrentError = 0

" WinEnter, BufWinEnter
let g:EclimShowQuickfixSigns = 0

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
