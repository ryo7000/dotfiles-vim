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
  set pythonthreedll=$VIM/python3/python38.dll
endif


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
  endif

  " :help tmux-integration
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors

  " Termでmouseを使う設定
  set mouse=a
  set ttymouse=sgr
endif

if has('win32') || has('win64')
  " for gf
  set isfname-=:
endif

set autoindent
set backspace=indent,eol,start
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
set diffopt& diffopt+=algorithm:histogram,indent-heuristic
set synmaxcol=320
set belloff=all

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

" DirDiff {{{2
let g:DirDiffExcludes = ".svn"

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
