packadd denite.nvim

nnoremap    [denite]   <Nop>
nmap    <Space> [denite]
nmap <silent> <C-s> [denite]c
nnoremap <silent> [denite]c :Denite file buffer<CR>
nnoremap <silent> [denite]d :Denite directory_rec<CR>
nnoremap <silent> [denite]b :DeniteBufferDir file<CR>
nnoremap <silent> [denite]r :Denite file_rec/git<CR>
nnoremap <silent> [denite]n :Denite file_mru<CR>
nnoremap <silent> [denite]u :Denite buffer<CR>
nnoremap <silent> [denite]o :Denite unite:outline<CR>

call denite#custom#option('default', {
      \ 'highlight_matched_char': 'Identifier',
      \ 'cursor_wrap': v:true })

call denite#custom#map('insert', '<C-n>',
      \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>',
      \ '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-w>',
      \ '<denite:move_up_path>', 'noremap')

call denite#custom#action('directory', 'rec',
      \ {context -> denite#start([{'name': 'file_rec', 'args': [context['targets'][0]['word']]}])})
call denite#custom#map('insert', '<C-r>',
      \ '<denite:do_action:rec>', 'noremap')

call denite#custom#alias('source', 'file_rec/git', 'file_rec')
call denite#custom#var('file_rec/git', 'command',
      \ ['git', 'ls-files', '-co', '--exclude-standard'])

call denite#custom#source(
      \ 'file_rec/git', 'matchers', ['matcher/cpsm'])
