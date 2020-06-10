nnoremap    [denite]   <Nop>
nmap    <Space> [denite]
nmap <silent> <C-s> [denite]c
nnoremap <silent> [denite]c :Denite file buffer<CR>
nnoremap <silent> [denite]d :Denite directory_rec<CR>
nnoremap <silent> [denite]b :DeniteBufferDir file<CR>
nnoremap <silent> [denite]r :Denite -start-filter file/rec<CR>
nnoremap <silent> [denite]n :Denite -start-filter file_mru<CR>
nnoremap <silent> [denite]u :Denite buffer<CR>
nnoremap <silent> [denite]o :Denite unite:outline<CR>

autocmd FileType denite call s:denite_settings()
function! s:denite_settings() abort
  nnoremap <silent><buffer><expr> <CR>
  \ denite#do_map('do_action')
  nnoremap <silent><buffer><expr> d
  \ denite#do_map('do_action', 'delete')
  nnoremap <silent><buffer><expr> p
  \ denite#do_map('do_action', 'preview')
  nnoremap <silent><buffer><expr> q
  \ denite#do_map('quit')
  nnoremap <silent><buffer><expr> i
  \ denite#do_map('open_filter_buffer')
  nnoremap <silent><buffer><expr> <Space>
  \ denite#do_map('toggle_select').'j'
endfunction

autocmd FileType denite-filter call s:denite_filter_settings()
function! s:denite_move_cursor(down) abort
  let winid = win_getid(winnr('#'))
  let pos = line('.', winid) + (a:down ? 1 : -1)
  call win_execute(winid, 'call cursor(' . pos . ', 0)|redraw')
  return ''
endfunction
function! s:denite_filter_settings() abort
  imap <silent><buffer> <C-o> <Plug>(denite_filter_quit)
  inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')

  imap <silent><buffer><expr> <C-j> <SID>denite_move_cursor(v:true)
  imap <silent><buffer><expr> <C-k> <SID>denite_move_cursor(v:false)
endfunction

call denite#custom#option('_', #{
  \ max_dynamic_update_candidates: 50000,
  \ highlight_matched_char: 'Identifier'})

call denite#custom#var('file/rec', 'command', ['rg', '--files', '--glob', '!.git'])
call denite#custom#source('file/rec', 'matchers', ['matcher/cpsm'])

let g:python3_host_prog = g:vim_home . '/python3/python.exe'
