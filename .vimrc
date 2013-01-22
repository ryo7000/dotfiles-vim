set nocompatible
filetype plugin indent off

if has('win32') || has('win64')
  let s:vim_home = $VIM
else
  let s:vim_home = $HOME
endif

if has('vim_starting')
  " Windowsで$HOME/vimfilesの代わりに、$VIM/.vimを使う
  if has('win32') || has('win64')
    " filetype onで、runtime! ftdetect/*.vimするので、
    " その前にruntimepathを設定
    " (filetype onは、syntax on/enableで読み込まれる$VIMRUNTIME/syntax/syntax.vimの中で実行される)
    set runtimepath=$VIM/.vim,$VIMRUNTIME,$VIM/.vim/after
  endif

  let &runtimepath .= ',' . s:vim_home . '/.vim/bundle/neobundle/'
  call neobundle#rc(expand(s:vim_home . '/.vim/bundle/'))
endif

" NeoBundle {{{1
let g:neobundle_default_git_protocol = 'https'

NeoBundle 'kana/vim-fakeclip.git', {'rev': '0.2.8'}
NeoBundle 'Shougo/unite.vim.git', {'rev': 'ver.3.1'}
NeoBundle 'Shougo/neocomplcache.git', {'rev': 'ver.7.0'}
NeoBundle 'Shougo/neocomplcache-snippets-complete.git', {'rev': 'ver.2.0'}
" v6.1-
NeoBundle 'Shougo/vimproc.git'

NeoBundle 'Shougo/vimfiler.git', {'rev': 'Ver.3.0'}
NeoBundle 'vim-ruby/vim-ruby.git'
NeoBundle 'h1mesuke/unite-outline.git', {'rev': 'v0.5.0'}
NeoBundle 'tpope/vim-rails.git', {'rev': 'v4.4'}
NeoBundle 'thinca/vim-ref', {'rev': 'unite-ref-v0.1.1'}
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'majutsushi/tagbar', {'rev': 'v2.4.1'}
NeoBundle 'http://repo.or.cz/r/vcscommand.git', {'rev': 'v1.99.46'}

"" $VIMRUNTIME/menu.vimを読みこまない
set guioptions&
set guioptions+=M
set guioptions-=T
set guioptions-=m

filetype plugin indent on

" Encoding {{{1

" for Japanese lang
if has('win32') || has('win64')
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
syntax enable

if !has("gui_running")
  if has('unix')
    set term=builtin_linux
  endif

  if !exists('g:colors_name')
    colorscheme solarized
    set background=dark
    let g:solarized_termcolors=256
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
set grepprg=grep\ -nH\ $*\ \\\|\ grep\ -v\ \"\\.svn\"
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

set ignorecase
set smartcase

if has('persistent_undo')
  set undodir=./.vimundo,~/.vimundo
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

" powerline
let g:Powerline_symbols = 'fancy'

" Unite {{{2

let g:unite_enable_start_insert = 1

nnoremap    [unite]   <Nop>
nmap    <Space> [unite]
nmap <silent> <C-s> [unite]c
nnoremap <silent> [unite]c :UniteWithCurrentDir -buffer-name=files file buffer file_mru bookmark<CR>
nnoremap <silent> [unite]b :UniteWithBufferDir -buffer-name=files -prompt=%\  file buffer file_mru bookmark<CR>
nnoremap <silent> [unite]n :Unite -buffer-name=files file_mru<CR>
nnoremap <silent> [unite]o :Unite outline<CR>
nnoremap <silent> [unite]g :Unite grep<CR>
nnoremap <silent> [unite]r :UniteResume<CR>

" replace buffer dir
call unite#set_substitute_pattern('files', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)

" replace current dir
call unite#set_substitute_pattern('files', '^@', '\=getcwd()."/*"', 1)

" replace home dir
call unite#set_substitute_pattern('files', '^\\', '~/*')

" fuzzy match
"call unite#set_substitute_pattern('files', '[[:alnum:]]', '*\0', -1)

" Unite中はsmartcase無視
call unite#set_buffer_name_option('files', 'smartcase', 0)


" neocomplcache {{{2
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Use underbar completion.
let g:neocomplcache_enable_underbar_completion = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_snippets_dir = s:vim_home . '/.vim/snippets'

imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
      \ "\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
smap <silent><TAB> <Plug>(neocomplcache_snippets_expand)

" VimFiler {{{2
let g:vimfiler_as_default_explorer = 1

" DirDiff {{{2

let g:DirDiffExcludes = ".svn"

" vim-ruby (rubycomplete.vim) {{{2
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_rails = 1
let g:rubycomplete_classes_in_global = 1

" git-commit {{{2
augroup gitcommit
  au FileType gitcommit DiffGitCached | wincmd R
augroup END

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

" fix SEGV for Gentoo + vim + rails.vim
" http://www.nabble.com/Omni-completion-stack-overflow-td8922044.html
silent! ruby nil

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
