filetype plugin on

"---------------------------------------------------------------------------
" vimrcの設定上書き
if has('win32')
  let $HOME="c:/online/vim"
endif
set nobackup
set nowrapscan
set pumheight=15
lang C

set wildmode=list:longest

if !has("gui_running")
  set t_Co=256
  colorscheme desert256
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

" closetag
let g:closetag_html_style=1
au Filetype html,xml,xsl,ant,tpl,php,eruby ru macros/closetag.vim

" tab navigation like firefox
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
map <C-w>t :tabnew<cr>

"---------------------------------------------------------------------------
" fuzzyfinder
nmap <unique> <silent> <C-s> :FuzzyFinderBuffer<CR>

let g:FuzzyFinderOptions = {
\   'key_next_mode'   : '<C-s>',
\   'mru_file' : {
\     'max_item' : 100,
\   },
\ }

" 現在のディレクトリからfileモードを開く
nnoremap <C-x> :let g:FuzzyFinderOptions.file.initial_text =
      \ expand('%')[:-1-len(expand('%:t'))]<CR>:FuzzyFinderFile<CR>

"---------------------------------------------------------------------------
" cscope関連

set cst
map g<C-]> :cs find c <C-R>=expand("<cword>")<CR><CR>

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

" ファイルフォーマットとエンコーディングを取得
function! GetStatusEx()
    let str = ''
    let str = str . '[' . &fileformat . ']'
    if has('multi_byte') && &fileencoding != ''
        let str = str . ' [' . &fileencoding . ']'
    endif
    return str
endfunction

set statusline=%n:\ %<%f%=%y\ %m%r%h%w%{GetStatusEx()}\ %l,%c\ %P 

"---------------------------------------------------------------------------
" cygwin連携

"set shell=c:\cygwin\bin\bash.exe
"set shellcmdflag=-c
"set shellxquote=\"
"set shellslash

"---------------------------------------------------------------------------
" その他

command! Dt execute("diffthis")
let g:mapleader = "\<C-k>"
set grepprg=grep\ -nH\ $*\ \\\|\ grep\ -v\ .svn
set shortmess+=I

" ff11 equip db 更新用関数
command! -nargs=+ -complete=command Db call Dbcall(<f-args>)

function! Dbcall(species, date)
	let s:spe = ""
	if a:species == "w"
		let s:spe = "weapon"
	elseif a:species == "a"
		let s:spe = "armor"
	elseif a:species == "i"
		let s:spe = "item"
	endif

	let s:url = "http://ryo:wqinbmxw@www.live-emotion.com/ff11/csv.php?species=". s:spe . "&date=" . a:date
	execute ("set ff=unix")
	execute ("set fenc=euc-jp")
	execute ("normal ggdG")
	execute ("Nread ". s:url)
	execute ("normal ggD")
endfunction

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

" autocomplpop.vim
" 候補は大文字小文字無視する
let g:AutoComplPop_IgnoreCaseOption=1
" 補完時の'complete'
let g:AutoComplPop_CompleteOption='.,w,b,u'
