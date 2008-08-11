filetype plugin on

"---------------------------------------------------------------------------
" vimrcの設定上書き
if has('win32')
  let $HOME=$VIM
  set isfname-=:
endif
set nobackup
set nowrapscan
set pumheight=15

set wildmode=list:longest

if !has("gui_running")
  set t_Co=256
  colorscheme desert256
  set mouse=a
  set ttymouse=xterm2
  hi Pmenu ctermbg=242
  hi PmenuSel cterm=reverse ctermfg=64 ctermbg=222
  hi PmenuSbar ctermbg=249
endif

"---------------------------------------------------------------------------
" タブ幅 & 改行関連

set listchars=tab:>-,eol:<
set ts=4
set sw=4
set cinoptions=g0,(0

nmap <C-n> :cn<CR>zz
nmap <C-p> :cp<CR>zz
nmap <C-j> :set list!<CR>
nmap <C-Enter> i<Enter><Esc>

" 親ディレクトリのtagsも検索
set tags+=tags;

" 検索語を画面の真ん中に
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" CTRL-Aで8進数の計算をさせない
set nrformats-=octal

" DirDiff
let g:DirDiffExcludes = ".svn"

" matchit
:source $VIMRUNTIME/macros/matchit.vim

" winmanager
let g:winManagerWindowLayout = "FileExplorer,BufExplorer|TagList"
let Tlist_Display_Tag_Scope = 0
map <c-w><c-t> :WMToggle<cr>
hi link MyTagListTagName Visual

" closetag
let g:closetag_html_style=1
au Filetype html,xml,xsl,ant,tpl,php,eruby ru macros/closetag.vim

" tab navigation like firefox
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
map <C-w>t :tabnew<cr>

" C-@でEsc
noremap <C-@>  <Esc>
noremap! <C-@>  <Esc>

" 日本語入力中にESCで、Nomalに戻る & 日本語入力を終了する
if has("gui_running")
  inoremap <ESC> <ESC>:set iminsert=0<CR>
endif

"---------------------------------------------------------------------------
" fuzzyfinder
let g:FuzzyFinderOptions = { 'Base':{}, 'Buffer':{}, 'File':{}, 'MruFile':{}, 'FavFile':{}, 'Dir':{}, 'Tag':{}, 'TaggedFile':{}}
let g:FuzzyFinderOptions.MruFile.max_item = 100
let g:FuzzyFinderOptions.Base.key_next_mode = '<C-s>'
let g:FuzzyFinderOptions.File.lasting_cache = 0
let g:FuzzyFinderOptions.Dir.lasting_cache = 0

nmap <unique> <silent> <C-s> :FuzzyFinderBuffer<CR>
nnoremap <C-q><C-b> :FuzzyFinderBuffer<CR>
nnoremap <C-q><C-n> :FuzzyFinderMruFile<CR>
nnoremap <C-q><C-v> :FuzzyFinderFavFile<CR>
nnoremap <C-q><C-d> :FuzzyFinderDir<CR>
nnoremap <C-q><C-t> :FuzzyFinderTag<CR>
nnoremap <C-q><C-p> :FuzzyFinderTag!<CR>
nnoremap <C-q><C-]> :FuzzyFinderTag! <C-r>=expand('<cword>')<CR><CR>
nnoremap <C-q><C-g> :FuzzyFinderTaggedFile<CR>
nnoremap <C-q><C-f> :FuzzyFinderFile<CR>

" ファイルのディレクトリからfileモードを開く
nnoremap <C-q><C-x> :FuzzyFinderFile <C-r>=expand('%:~:.')[:-1-len(expand('%:~:.:t'))]<CR><CR>

"---------------------------------------------------------------------------
" autocomplpop

" 候補は大文字小文字無視する
let g:AutoComplPop_IgnoreCaseOption = 1
" 補完時の'complete'
let g:AutoComplPop_CompleteOption = '.,w,b,u'
" キーワード補完の最小文字数を3に
let g:AutoComplPop_BehaviorKeywordLength = 3

"---------------------------------------------------------------------------
" cscope関連

set cst
map g<C-]> :cs find c <C-R>=expand("<cword>")<CR><CR>
set cscopequickfix=s-,c-,d-,i-,t-,e-

"---------------------------------------------------------------------------
" ファイルエクスプローラに関する設定

" 垂直分割
let g:explVertical=1
" ファイルをエクスプローラの右のウィンドウに表示
let g:explSplitRight=1
" エクスプローラをカレントウィンドウの左側に開いて表示
let g:explStartRight=0

"---------------------------------------------------------------------------
" ステータスラインに関する設定

set statusline=%n:\ %<%f%=%y\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}\ %l,%c\ %P 

"---------------------------------------------------------------------------
" その他

let g:mapleader = "\<C-k>"
set grepprg=grep\ -nH\ $*\ \\\|\ grep\ -v\ .svn
set shortmess+=I

" set fenc
nmap <silent> eu :set fenc=utf-8<CR>
nmap <silent> ee :set fenc=euc-jp<CR>
nmap <silent> es :set fenc=cp932<CR>

" e ++enc
nmap <silent> eru :e ++enc=utf-8<CR>
nmap <silent> ere :e ++enc=euc-jp<CR>
nmap <silent> ers :e ++enc=cp932<CR>

" rails.vim
com! -bar -nargs=1 OpenURL call OpenNewTab("<args>")

" fix SEGV for Gentoo + vim + rails.vim
" http://www.nabble.com/Omni-completion-stack-overflow-td8922044.html
silent! ruby nil
