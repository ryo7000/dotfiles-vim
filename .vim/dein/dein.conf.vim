function! s:init(path, filename)
  let dein_home = g:vim_home . '/.vim/dein'
  let dein_repo = dein_home . '/dein.vim'

  if has('vim_starting')
    let &runtimepath .= ',' . a:path . '/configs'
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
    "   \ #{depends: ['roxma/nvim-yarp', 'roxma/vim-hug-neovim-rpc'],
    "   \   hook_add: 'source ' . dein_home . '/configs/denite.vim'})
    " call dein#add('roxma/nvim-yarp')
    " call dein#add('roxma/vim-hug-neovim-rpc')

    call dein#add('Shougo/neosnippet', #{hook_add: 'source ' . dein_home . '/configs/neosnippet.vim'})
    call dein#add('Shougo/neosnippet-snippets')
    call dein#add('justinmk/vim-dirvish', #{hook_add: 'source ' . dein_home . '/configs/vim-dirvish.vim'})
    call dein#add('tpope/vim-eunuch')
    call dein#add('Shougo/neomru.vim')
    call dein#add('thinca/vim-ref')
    call dein#add('w0rp/ale', #{rev: 'v3.0.0', hook_add: 'source ' . dein_home . '/configs/ale.vim'})
    call dein#add('maximbaz/lightline-ale', #{depends: ['w0rp/ale', 'itchyny/lightline.vim']})
    call dein#add('itchyny/lightline.vim', #{hook_add: 'source ' . dein_home . '/configs/lightline.vim'})
    call dein#add('majutsushi/tagbar', #{rev: 'v2.6.1', hook_add: 'source ' . dein_home . '/configs/tagbar.vim'})
    call dein#add('tpope/vim-fugitive', #{hook_add: 'source ' . dein_home . '/configs/vim-fugitive.vim'})
    call dein#add('tpope/vim-surround')
    call dein#add('vim-scripts/vcscommand.vim')
    call dein#add('thinca/vim-quickrun', #{hook_add: 'source ' . dein_home . '/configs/vim-quickrun.vim'})
    call dein#add('qpkorr/vim-renamer')
    call dein#add('vim-scripts/Align')
    call dein#add('kannokanno/previm')
    call dein#add('tyru/open-browser.vim')
    call dein#add('ntpeters/vim-better-whitespace', #{hook_add: 'source ' . dein_home . '/configs/vim-better-whitespace.vim'})
    call dein#add('Shougo/vimproc.vim', #{hook_post_update: 'call installer#vimproc()'})
    call dein#add('nixprime/cpsm', #{hook_post_update: 'call installer#cpsm()'})
    call dein#add('jonathanfilip/vim-lucius')
    call dein#add('mattn/webapi-vim')
    call dein#add('mattn/gist-vim', #{depends: ['mattn/webapi-vim'], hook_add: 'source ' . dein_home . '/configs/gist-vim.vim'})
    call dein#add('prabirshrestha/async.vim')
    call dein#add('othree/eregex.vim', #{hook_add: 'source ' . dein_home . '/configs/eregex.vim'})
    call dein#add('liuchengxu/vim-clap', #{hook_post_update: 'call installer#vim_clap()', hook_add: 'source ' . dein_home . '/configs/vim-clap.vim'})

    " asyncomplete
"   call dein#add('prabirshrestha/vim-lsp', #{hook_add: 'source ' . dein_home . '/configs/vim-lsp.vim'})
"   call dein#add('prabirshrestha/asyncomplete.vim')
"   call dein#add('prabirshrestha/asyncomplete-lsp.vim')
"   call dein#add('prabirshrestha/asyncomplete-buffer.vim', #{hook_add: 'source ' . dein_home . '/configs/asyncomplete-buffer.vim'})
"   call dein#add('prabirshrestha/asyncomplete-file.vim', #{hook_add: 'source ' . dein_home . '/configs/asyncomplete-file.vim'})
    call dein#add('neoclide/coc.nvim', #{lazy: 1, on_event: ['VimEnter'], rev: 'release', hook_post_source: 'source ' . dein_home . '/configs/coc.vim'})

    " lazy
    call dein#add('plasticboy/vim-markdown', #{lazy: 1, on_ft: 'markdown', hook_source: 'source ' . dein_home . '/configs/vim-markdown.vim'})
    call dein#add('lilydjwg/colorizer',
      \ #{lazy: 1,
      \   on_cmd: [
      \    'ColorToggle',
      \    'ColorHighlight',
      \    'ColorClear'
      \  ]})
    call dein#add('thinca/vim-logcat', #{lazy: 1, on_ft: 'logcat'})

    " javascript
    call dein#add('pangloss/vim-javascript', #{lazy: 1, on_ft: ['javascript']})
    call dein#add('othree/yajs.vim', #{lazy: 1, on_ft: ['javascript']})
    call dein#add('othree/es.next.syntax.vim', #{lazy: 1, on_ft: ['javascript']})
    call dein#add('MaxMEllon/vim-jsx-pretty', #{lazy: 1, on_ft: ['javascript']})
    call dein#add('moll/vim-node', #{lazy: 1, on_ft: ['javascript']})
    call dein#add('leafgarland/typescript-vim', #{lazy: 1, on_ft: 'typescript'})
    call dein#add('posva/vim-vue', #{lazy: 1, on_ft: 'vue'})

    " ruby
    call dein#add('vim-ruby/vim-ruby', #{lazy: 1, on_ft: ['ruby', 'eruby'], hook_source: 'source ' . dein_home . '/configs/vim-ruby.vim'})
    call dein#add('slim-template/vim-slim', #{lazy: 1, on_ft: 'slim'})
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
