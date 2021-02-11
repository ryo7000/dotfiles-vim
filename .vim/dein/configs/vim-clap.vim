nnoremap    [clap]   <Nop>
nmap    <Space> [clap]
nmap <silent> <C-s> [clap]c
nnoremap <silent> [clap]c :Clap filer<CR>
nnoremap <silent> [clap]n :Clap history<CR>
nnoremap <silent> [clap]r :Clap files<CR>

let g:clap_theme = 'atom_dark'
let g:clap_layout = { 'relative': 'editor' }
if exists('*matchfuzzypos')
  " use vim builtin matchfuzzy
  let g:clap_force_matchfuzzy = v:true
endif
