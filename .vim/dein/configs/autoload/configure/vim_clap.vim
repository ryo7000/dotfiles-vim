function! configure#vim_clap#hooks()
  return #{
  \ hook_post_update: 'call configure#vim_clap#hook_post_update()',
  \ hook_add: 'call configure#vim_clap#hook_add()',
  \}
endfunction

function! configure#vim_clap#hook_post_update()
  echo 'Building: vim_clap'
  if has('win32') || has('win64')
    call system('powershell.exe .\install.ps1')
  else
    call system('./install.sh')
  end
endfunction

function! configure#vim_clap#hook_add()
  nnoremap    [clap]   <Nop>
  nmap    <Space> [clap]
  nmap <silent> <C-s> [clap]c
  nnoremap <silent> [clap]c :Clap filer<CR>
  nnoremap <silent> [clap]n :Clap history<CR>
  nnoremap <silent> [clap]r :Clap files<CR>
  nnoremap <silent> [clap]q :Clap quick_open<CR>

  let g:clap_theme = 'atom_dark'
  let g:clap_layout = { 'relative': 'editor' }
  if exists('*matchfuzzypos')
    " use vim builtin matchfuzzy
    let g:clap_force_matchfuzzy = v:true
  endif

  let g:clap_provider_quick_open = {
  \ 'source': [
  \   '/home/ryo/',
  \ ],
  \ 'sink': 'Clap files'
  \ }
endfunction

