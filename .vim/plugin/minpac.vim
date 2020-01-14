function! PackInit() abort
  packadd minpac

  call minpac#init()
  call minpac#add('k-takata/minpac', {'type': 'opt'})

  call minpac#add('vim-jp/vimdoc-ja')
  call minpac#add('kana/vim-fakeclip', {'rev': '0.3.0'})
  call minpac#add('will133/vim-dirdiff')
  call minpac#add('cespare/vim-toml')
  call minpac#add('Shougo/unite.vim')
  call minpac#add('Shougo/denite.nvim', {'rev': '1.2'})
  call minpac#add('Shougo/neosnippet')
  call minpac#add('Shougo/neosnippet-snippets')
  call minpac#add('justinmk/vim-dirvish')
  call minpac#add('tpope/vim-eunuch')
  call minpac#add('Shougo/unite-outline') " depends: Shougo/unite.vim
  call minpac#add('Shougo/neomru.vim') " depends: Shougo/unite.vim
  call minpac#add('thinca/vim-ref')
  call minpac#add('w0rp/ale', {'rev': 'v2.6.0'})
  call minpac#add('itchyny/lightline.vim')
  call minpac#add('maximbaz/lightline-ale') " depends: w0rp/ale, itchyny/lightline.vim
  call minpac#add('majutsushi/tagbar', {'rev': 'v2.6.1'})
  call minpac#add('tpope/vim-fugitive', {'rev': 'v3.2'})
  call minpac#add('tpope/vim-surround')
  call minpac#add('vim-scripts/vcscommand.vim')
  call minpac#add('thinca/vim-quickrun')
  call minpac#add('leafgarland/typescript-vim')
  call minpac#add('qpkorr/vim-renamer')
  call minpac#add('vim-scripts/Align')
  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('kannokanno/previm')
  call minpac#add('tyru/open-browser.vim')
  call minpac#add('ntpeters/vim-better-whitespace')
  call minpac#add('Shougo/vimproc.vim', {'do': function('s:vimproc_do')})
  call minpac#add('nixprime/cpsm', {'do': function('s:cpsm_do')})
  call minpac#add('thinca/vim-logcat')
  call minpac#add('jonathanfilip/vim-lucius')
  call minpac#add('mattn/webapi-vim')
  call minpac#add('mattn/gist-vim') " depends mattn/webapi-vim
  call minpac#add('prabirshrestha/async.vim')
  call minpac#add('prabirshrestha/vim-lsp')
  call minpac#add('prabirshrestha/asyncomplete.vim')
  call minpac#add('prabirshrestha/asyncomplete-lsp.vim')
  call minpac#add('prabirshrestha/asyncomplete-buffer.vim')
  call minpac#add('prabirshrestha/asyncomplete-file.vim')
  call minpac#add('lilydjwg/colorizer')

  " javascript
  call minpac#add('othree/yajs.vim')
  call minpac#add('vim-ruby/vim-ruby')
  call minpac#add('pangloss/vim-javascript')
  call minpac#add('moll/vim-node')
  call minpac#add('posva/vim-vue')

  call minpac#add('tpope/vim-rails', {'type': 'opt'})
endfunction

function! s:vimproc_do(hooktype, name)
  if executable('make')
    call system('make')
  endif
endfunction

function! s:cpsm_do(hooktype, name)
  if executable('make')
    call system('sh -c "PY3=ON ./install.sh"')
  endif
endfunction

" Define user commands for updating/cleaning the plugins.
" Each of them calls PackInit() to load minpac and register
" the information of plugins, then performs the task.
command! PackUpdate call PackInit() | call minpac#update('', {'do': 'call minpac#status()'})
command! PackClean  call PackInit() | call minpac#clean()
command! PackStatus call PackInit() | call minpac#status()
