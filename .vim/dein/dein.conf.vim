if has('vim_starting')
  let &runtimepath .= ',' . g:vim_home . '/.vim/dein/dein.vim/'
endif

let s:dein_dir = expand(g:vim_home . '/.vim/dein/')

if !isdirectory(s:dein_dir . 'dein.vim')
  echom 'dein.vim is not installed. please install by following command'
  echom 'git clone https://github.com/Shougo/dein.vim ~/.vim/dein/dein.vim'
  finish
endif

if dein#load_state(s:dein_dir)
  let s:toml      = s:dein_dir . '/dein.toml'
  let s:lazy_toml = s:dein_dir . '/dein_lazy.toml'

  call dein#begin(s:dein_dir, [s:toml, s:lazy_toml])

  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

let g:vimproc#download_windows_dll = 1
