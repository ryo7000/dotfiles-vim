set nocompatible

" Windowsで$HOME/vimfilesの代わりに、$VIM/.vimを使う
if has('win32')
  " filetype onで、runtime! ftdetect/*.vimするので、
  " その前にruntimepathを設定
  " (filetype onは、syntax on/enableで読み込まれる$VIMRUNTIME/syntax/syntax.vimの中で実行される)
  set runtimepath=$VIM/.vim,$VIMRUNTIME,$VIM/.vim/after
endif

" Encoding {{{1

" for Japanese lang
if has('win32')
  set encoding=japan
else
  set encoding=utf-8
end

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

" $VIMRUNTIME/menu.vimを読みこまない
set guioptions&
"set guioptions+=M
set guioptions-=T
set guioptions-=m

syntax enable
filetype plugin indent on

if !has("gui_running")
  if has('unix')
    set term=builtin_linux
  endif

  if !exists('g:colors_name')
    colorscheme desert256
    set background=dark
  endif

  set t_Co=256

  " Termでmouseを使う設定
  "set mouse=a
  "set ttymouse=xterm2

  hi Pmenu ctermbg=242
  hi PmenuSel cterm=reverse ctermfg=64 ctermbg=222
  hi PmenuSbar ctermbg=249
endif

if has('win32')
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
set grepprg=grep\ -nH\ $*\ \\\|\ grep\ -v\ \"\\.svn\"
set history=100
set hlsearch
set incsearch
set listchars=tab:>-,eol:<
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

set ignorecase
set smartcase

" 親ディレクトリのtagsも検索
set tags& tags+=tags;

" cscope関連
set cst
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
if has("gui_running")
  inoremap <ESC> <ESC>:set iminsert=0<CR>
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

" tab navigation like firefox {{{2
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
map <C-w>t :tabnew<cr>

" C-@でEsc
noremap <C-@> <Esc>
noremap! <C-@> <Esc>

" 検索語を画面の真ん中に {{{2
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
 
" set fenc {{{2
nmap <silent> eu :set fenc=utf-8<CR>
nmap <silent> ee :set fenc=euc-jp<CR>
nmap <silent> es :set fenc=cp932<CR>

" e ++enc {{{2
nmap <silent> eru :e ++enc=utf-8<CR>
nmap <silent> ere :e ++enc=euc-jp<CR>
nmap <silent> ers :e ++enc=cp932<CR>

" Plugins & Macros {{{1

" matchit
so $VIMRUNTIME/macros/matchit.vim

" fuzzyfinder {{{2

let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'Dir':{}, 'MruFile':{}, 'MruCmd':{}, 'Bookmark':{}, 'Tag':{}, 'TaggedFile':{}}
if has('win32')
  let g:FuzzyFinderOptions.Base.info_file = '$VIM/.vimfuzzyfinder'
else
  let g:FuzzyFinderOptions.Base.info_file = '$HOME/.vimfuzzyfinder'
endif
let g:FuzzyFinderOptions.MruFile.max_item = 100
let g:FuzzyFinderOptions.MruFile.enumerating_limit = 50
let g:FuzzyFinderOptions.Base.key_next_mode = '<C-s>'
let g:FuzzyFinderOptions.File.lasting_cache = 0
let g:FuzzyFinderOptions.Dir.lasting_cache = 0
let g:FuzzyFinderOptions.Tag.enumerating_limit = 50
let g:FuzzyFinderOptions.TaggedFile.enumerating_limit = 50

nmap <silent> <C-s> :FuzzyFinderBuffer<CR>
nnoremap <C-q><C-b> :FuzzyFinderBuffer<CR>
nnoremap <C-q><C-n> :FuzzyFinderMruFile<CR>
nnoremap <C-q><C-v> :FuzzyFinderBookmark<CR>
nnoremap <C-q><C-d> :FuzzyFinderDir<CR>
nnoremap <C-q><C-t> :FuzzyFinderTag!<CR>
nnoremap <C-q><C-]> :FuzzyFinderTagWithCursorWord!<CR>
nnoremap <C-q><C-g> :FuzzyFinderTaggedFile<CR>
nnoremap <C-q><C-f> :FuzzyFinderFile<CR>
nnoremap <C-q><C-x> :FuzzyFinderFileWithCurrentBufferDir<CR>

" autocomplpop {{{2

" 候補は大文字小文字無視する
let g:AutoComplPop_IgnoreCaseOption = 1
" 補完時の'complete'
let g:AutoComplPop_CompleteOption = '.,w,b,u'
" キーワード補完の最小文字数を3に
let g:AutoComplPop_BehaviorKeywordLength = 3
" RubyのSymbol補完を行わない
let g:AutoComplPop_Behavior = {
\ 'ruby' : [
\ {
\ 'command' : "\<C-n>",
\ 'pattern' : '\k\k$',
\ 'excluded' : '^$',
\ 'repeat' : 0,
\ },
\ {
\ 'command' : "\<C-x>\<C-f>",
\ 'pattern' : (has('win32') || has('win64') ? '\f[/\\]\f*$' : '\f[/]\f*$'),
\ 'excluded' : '[*/\\][/\\]\f*$\|[^[:print:]]\f*$',
\ 'repeat' : 1,
\ },
\ {
\ 'command' : "\<C-x>\<C-o>",
\ 'pattern' : '\([^. \t]\.\|::\)$',
\ 'excluded' : (has('ruby') ? '^$' : '.*'),
\ 'repeat' : 0,
\ },
\ ],
\ }

" DirDiff {{{2

let g:DirDiffExcludes = ".svn"

" winmanager {{{2

let g:winManagerWindowLayout = "TagList"
let g:winManagerWidth = 40
map <c-w><c-t> :WMToggle<cr>
hi link MyTagListTagName Visual

" git-commit {{{2
let git_diff_spawn_mode=1
autocmd BufNewFile,BufRead COMMIT_EDITMSG set filetype=git

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

" fix SEGV for Gentoo + vim + rails.vim
" http://www.nabble.com/Omni-completion-stack-overflow-td8922044.html
silent! ruby nil

" closetag
let g:closetag_html_style=1
augroup CloseTagMacro
  au!
  au Filetype html,xml,xsl,ant,tpl,php,eruby ru macros/closetag.vim
augroup END

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
" vim: et sts=2 sw=2 fdm=marker fdc=3
