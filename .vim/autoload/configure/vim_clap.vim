function! configure#vim_clap#hooks()
  return #{
  \ do: { -> configure#vim_clap#do() },
  \ hook_post_source: 'call configure#vim_clap#hook_post_source()',
  \}
endfunction

function! configure#vim_clap#do()
  call clap#installer#force_download()
endfunction

function! configure#vim_clap#files()
  if (strpart(bufname(), 0, 4) ==# "fern")
    execute 'Clap files ' . getcwd()
  else
    execute 'Clap files'
  endif
endfunction

function! configure#vim_clap#hook_post_source()
  nnoremap    [clap]   <Nop>
  nmap    <Space> [clap]
  nmap <silent> <C-s> [clap]c
  nnoremap <silent> [clap]c :Clap filer<CR>
  nnoremap <silent> [clap]n :Clap history<CR>
  nnoremap <silent> [clap]r :call configure#vim_clap#files()<CR>
  nnoremap <silent> [clap]q :Clap quick_open<CR>
  nnoremap <silent> [clap]w :Clap windows<CR>

  let g:clap_theme = 'atom_dark'
  let g:clap_layout = { 'relative': 'editor' }
  if exists('*matchfuzzypos')
    " use vim builtin matchfuzzy
    let g:clap_force_matchfuzzy = v:true
  endif

  let g:clap_provider_quick_open = {
  \ 'source': [
  \   'home                              /home/ryo',
  \ ],
  \ 'sink': { selected -> execute('Fern '.split(selected)[1]) },
  \ }
endfunction
