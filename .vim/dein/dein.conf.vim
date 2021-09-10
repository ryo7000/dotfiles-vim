function! s:init(path, filename)
  let dein_home = g:vim_home . '/.vim/dein'
  let dein_repo = dein_home . '/dein.vim'

  if has('vim_starting')
    let &runtimepath .= ',' . dein_repo
  endif

  if !isdirectory(dein_repo)
    echom 'dein.vim is not installed. please install by following command'
    echom 'git clone https://github.com/Shougo/dein.vim ~/.vim/dein/dein.vim'
    finish
  endif

  if dein#load_state(dein_home)
    call dein#begin(dein_home, [a:filename])
    call dein#add(dein_repo)

    call dein#add('vim-jp/vimdoc-ja', #{type__depth: 1})
    call dein#add('kana/vim-fakeclip')
    call dein#add('will133/vim-dirdiff')
    call dein#add('cespare/vim-toml')

    " for unite:outline source
    call dein#add('Shougo/unite.vim')
    call dein#add('Shougo/unite-outline', #{depends: 'Shougo/unite.vim'})

    " denite
    " call dein#add('Shougo/denite.nvim',
    "   \ extend(#{depends: ['roxma/nvim-yarp', 'roxma/vim-hug-neovim-rpc']},
    "   \   configure#denite#hooks()))
    " call dein#add('roxma/nvim-yarp')
    " call dein#add('roxma/vim-hug-neovim-rpc')

    call dein#add('justinmk/vim-dirvish', configure#vim_dirvish#hooks())
    call dein#add('tpope/vim-eunuch')
    call dein#add('Shougo/neomru.vim')
    call dein#add('thinca/vim-ref')
    call dein#add('w0rp/ale', extend(#{rev: 'v3.0.0'}, configure#ale#hooks()))
    call dein#add('maximbaz/lightline-ale', #{depends: ['w0rp/ale', 'itchyny/lightline.vim']})
    call dein#add('itchyny/lightline.vim', configure#lightline#hooks())
    call dein#add('majutsushi/tagbar', extend(#{rev: 'v2.6.1'}, configure#tagbar#hooks()))
    call dein#add('tpope/vim-fugitive', configure#vim_fugitive#hooks())
    call dein#add('tpope/vim-surround')
    call dein#add('vim-scripts/vcscommand.vim')
    call dein#add('thinca/vim-quickrun', configure#vim_quickrun#hooks())
    call dein#add('qpkorr/vim-renamer')
    call dein#add('vim-scripts/Align')
    call dein#add('kannokanno/previm')
    call dein#add('tyru/open-browser.vim')
    call dein#add('ntpeters/vim-better-whitespace', configure#vim_better_whitespace#hooks())
    call dein#add('Shougo/vimproc.vim', configure#vimproc#hooks())
    call dein#add('nixprime/cpsm', configure#cpsm#hooks())
    call dein#add('jonathanfilip/vim-lucius')
    call dein#add('mattn/webapi-vim')
    call dein#add('mattn/gist-vim', extend(#{depends: ['mattn/webapi-vim']}, configure#gist_vim#hooks()))
    call dein#add('prabirshrestha/async.vim')
    call dein#add('othree/eregex.vim', configure#eregex#hooks())
    call dein#add('liuchengxu/vim-clap', extend(#{lazy: v:true, on_event: ['VimEnter']}, configure#vim_clap#hooks()))

    " asyncomplete
"   call dein#add('prabirshrestha/vim-lsp', configure#vim_lsp#hooks())
"   call dein#add('prabirshrestha/asyncomplete.vim')
"   call dein#add('prabirshrestha/asyncomplete-lsp.vim')
"   call dein#add('prabirshrestha/asyncomplete-buffer.vim', configure#asyncomplete_buffer#hooks())
"   call dein#add('prabirshrestha/asyncomplete-file.vim', configure#asyncomplete_file#hooks())
    call dein#add('neoclide/coc.nvim', extend(#{lazy: 1, on_event: ['VimEnter'], rev: 'release'}, configure#coc#hooks()))

    " lazy
    call dein#add('plasticboy/vim-markdown', extend(#{lazy: 1, on_ft: 'markdown'}, configure#vim_markdown#hooks()))
    call dein#add('lilydjwg/colorizer',
      \ #{lazy: 1,
      \   on_cmd: [
      \    'ColorToggle',
      \    'ColorHighlight',
      \    'ColorClear'
      \  ]})
    call dein#add('thinca/vim-logcat', #{lazy: 1, on_ft: 'logcat'})

    " javascript
    call dein#add('pangloss/vim-javascript')
    call dein#add('othree/yajs.vim')
    call dein#add('othree/es.next.syntax.vim')
    call dein#add('MaxMEllon/vim-jsx-pretty')
    call dein#add('moll/vim-node', #{lazy: 1, on_ft: ['javascript']})
    call dein#add('leafgarland/typescript-vim')
    call dein#add('posva/vim-vue')

    " ruby
    call dein#add('vim-ruby/vim-ruby', extend(#{lazy: 1, on_ft: ['ruby', 'eruby']}, configure#vim_ruby#hooks()))
    call dein#add('slim-template/vim-slim')
    call dein#add('tpope/vim-rails', #{lazy: 1, on_ft: ['ruby', 'eruby']})

    " go
    "call dein#add('fatih/vim-go', #{lazy: 1, on_ft: 'go', hook_post_source:  'source ' . dein_home . '/configs/asyncomplete-buffer.vim'})

    call dein#end()
    call dein#save_state()
  endif

  if dein#check_install()
    call dein#install()
  endif

  let g:vimproc#download_windows_dll = 1
endfunction

call s:init(expand('<sfile>:p:h'), expand('<sfile>'))
