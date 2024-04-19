let s:jetpackfile = expand('<sfile>:p:h') .. '/pack/jetpack/opt/vim-jetpack/plugin/jetpack.vim'
let s:jetpackurl = "https://raw.githubusercontent.com/tani/vim-jetpack/master/plugin/jetpack.vim"
if !filereadable(s:jetpackfile)
    call system(printf('curl -fsSLo %s --create-dirs %s', s:jetpackfile, s:jetpackurl))
endif

packadd vim-jetpack
call jetpack#begin()
call jetpack#add('tani/vim-jetpack', {'opt': 1}) "bootstrap

" colorschme設定でhighlight clearされるため先頭で呼び出す
call jetpack#add('jonathanfilip/vim-lucius', configure#lucius#hooks())
call jetpack#add('vim-jp/vimdoc-ja', #{type__depth: 1})
call jetpack#add('kana/vim-fakeclip')
call jetpack#add('will133/vim-dirdiff')
call jetpack#add('cespare/vim-toml')

" for unite:outline source
call jetpack#add('Shougo/unite.vim')
call jetpack#add('Shougo/unite-outline', #{depends: 'Shougo/unite.vim'})

" denite
" call jetpack#add('Shougo/denite.nvim',
"   \ extend(#{depends: ['roxma/nvim-yarp', 'roxma/vim-hug-neovim-rpc']},
"   \   configure#denite#hooks()))
" call jetpack#add('roxma/nvim-yarp')
" call jetpack#add('roxma/vim-hug-neovim-rpc')

call jetpack#add('lambdalisue/fern.vim', configure#fern#hooks())
call jetpack#add('lambdalisue/fern-git-status.vim', #{depends: 'fern.vim'})
call jetpack#add('lambdalisue/fern-hijack.vim', #{depends: 'fern.vim'})
call jetpack#add('tpope/vim-eunuch')
call jetpack#add('Shougo/neomru.vim')
call jetpack#add('thinca/vim-ref')
call jetpack#add('itchyny/lightline.vim', configure#lightline#hooks())
call jetpack#add('majutsushi/tagbar', extend(#{tag: 'v2.6.1'}, configure#tagbar#hooks()))
call jetpack#add('tpope/vim-fugitive', configure#vim_fugitive#hooks())
call jetpack#add('tpope/vim-surround')
call jetpack#add('vim-scripts/vcscommand.vim')
call jetpack#add('thinca/vim-quickrun', configure#vim_quickrun#hooks())
call jetpack#add('qpkorr/vim-renamer')
call jetpack#add('vim-scripts/Align')
call jetpack#add('kannokanno/previm')
call jetpack#add('tyru/open-browser.vim')
call jetpack#add('ntpeters/vim-better-whitespace', configure#vim_better_whitespace#hooks())
call jetpack#add('Shougo/vimproc.vim', configure#vimproc#hooks())
call jetpack#add('nixprime/cpsm', configure#cpsm#hooks())
call jetpack#add('mattn/webapi-vim')
call jetpack#add('mattn/gist-vim', extend(#{depends: ['mattn/webapi-vim']}, configure#gist_vim#hooks()))
call jetpack#add('prabirshrestha/async.vim')
call jetpack#add('othree/eregex.vim', configure#eregex#hooks())
call jetpack#add('liuchengxu/vim-clap', extend(#{on_event: ['VimEnter']}, configure#vim_clap#hooks()))
call jetpack#add('rbtnn/vim-ambiwidth', configure#ambiwidth#hooks())

" asyncomplete
" call jetpack#add('prabirshrestha/vim-lsp', configure#vim_lsp#hooks())
" call jetpack#add('prabirshrestha/asyncomplete.vim')
" call jetpack#add('prabirshrestha/asyncomplete-lsp.vim')
" call jetpack#add('prabirshrestha/asyncomplete-buffer.vim', configure#asyncomplete_buffer#hooks())
" call jetpack#add('prabirshrestha/asyncomplete-file.vim', configure#asyncomplete_file#hooks())
call jetpack#add('neoclide/coc.nvim', extend(#{branch: 'release'}, configure#coc#hooks()))
call jetpack#add('josa42/vim-lightline-coc', extend(#{depends: ['lightline.vim']}, configure#lightline_coc#hooks()))

" lazy
call jetpack#add('plasticboy/vim-markdown', extend(#{on_ft: 'markdown'}, configure#vim_markdown#hooks()))
call jetpack#add('lilydjwg/colorizer',
  \ #{
  \   on_cmd: [
  \    'ColorToggle',
  \    'ColorHighlight',
  \    'ColorClear'
  \  ]})
call jetpack#add('thinca/vim-logcat', #{on_ft: 'logcat'})

" javascript
call jetpack#add('pangloss/vim-javascript')
call jetpack#add('othree/yajs.vim')
call jetpack#add('othree/es.next.syntax.vim')
call jetpack#add('MaxMEllon/vim-jsx-pretty')
call jetpack#add('moll/vim-node', #{on_ft: ['javascript']})
call jetpack#add('leafgarland/typescript-vim')
call jetpack#add('posva/vim-vue')

" ruby
call jetpack#add('vim-ruby/vim-ruby', extend(#{on_ft: ['ruby', 'eruby']}, configure#vim_ruby#hooks()))
call jetpack#add('slim-template/vim-slim')
call jetpack#add('tpope/vim-rails', #{on_ft: ['ruby', 'eruby']})

" dart
call jetpack#add('dart-lang/dart-vim-plugin', #{on_ft: ['dart']})

" go
"call jetpack#add('fatih/vim-go', #{on_ft: 'go', hook_post_source:  'source ' . dein_home . '/configs/asyncomplete-buffer.vim'})

" rust
call jetpack#add('rust-lang/rust.vim', #{on_ft: ['rust']})

call jetpack#end()
