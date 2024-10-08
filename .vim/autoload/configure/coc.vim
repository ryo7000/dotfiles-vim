function! configure#coc#hooks()
  return #{
  \ hook_add: 'call configure#coc#hook_add()',
  \}
endfunction

function! configure#coc#add_extensions(list)
  if (!exists('g:coc_global_extensions'))
    let g:coc_global_extensions = []
  endif
  call extend(g:coc_global_extensions, a:list)
  let g:coc_global_extensions = uniq(sort(g:coc_global_extensions))
endfunction

function! configure#coc#hook_add()
  " Always show the signcolumn, otherwise it would shift the text each time
  " diagnostics appear/become resolved.
  set signcolumn=yes

  " Use tab for trigger completion with characters ahead and navigate.
  " NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
  " other plugin before putting this into your config.
  inoremap <silent><expr> <TAB>
        \ coc#pum#visible() ? coc#pum#next(1):
        \ CheckBackspace() ? "\<Tab>" :
        \ coc#refresh()
  inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

  " Make <CR> to accept selected completion item or notify coc.nvim to format
  " <C-g>u breaks current undo, please make your own choice.
  inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                                \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

  function! CheckBackspace() abort
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  " GoTo code navigation.
  nmap <silent> <C-]> <plug>(coc-definition)
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call ShowDocumentation()<CR>

  function! ShowDocumentation()
    if CocAction('hasProvider', 'hover')
      call CocActionAsync('doHover')
    else
      call feedkeys('K', 'in')
    endif
  endfunction

  " Highlight the symbol and its references when holding the cursor.
  autocmd CursorHold * silent call CocActionAsync('highlight')

  " Symbol renaming.
  nmap <leader>rn <Plug>(coc-rename)

  " Formatting selected code.
  xmap <leader>f  <Plug>(coc-format-selected)
  nmap <leader>f  <Plug>(coc-format-selected)

  augroup mygroup
    autocmd!
    " Setup formatexpr specified filetype(s).
    autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
    " Update signature help on jump placeholder.
    autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
  augroup end

  " Applying codeAction to the selected region.
  " Example: `<leader>aap` for current paragraph
  xmap <leader>a  <Plug>(coc-codeaction-selected)
  nmap <leader>a  <Plug>(coc-codeaction-selected)

  " Remap keys for applying codeAction to the current buffer.
  nmap <nowait> <leader>ac  <Plug>(coc-codeaction)
  " Apply AutoFix to problem on the current line.
  nmap <leader>qf  <Plug>(coc-fix-current)

  " Run the Code Lens action on the current line.
  nmap <leader>cl  <Plug>(coc-codelens-action)

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)

  " Add `:Format` command to format current buffer.
  command! -nargs=0 Format :call CocAction('format')

  " Add `:Fold` command to fold current buffer.
  command! -nargs=? Fold :call     CocAction('fold', <f-args>)

  " Add `:OR` command for organize imports of the current buffer.
  command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

  " Add (Neo)Vim's native statusline support.
  " NOTE: Please see `:h coc-status` for integrations with external plugins that
  " provide custom statusline: lightline.vim, vim-airline.
  set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

  " Mappings for CoCList
  " Show all diagnostics.
  nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
  " Manage extensions.
  nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
  " Show commands.
  nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
  " Find symbol of current document.
  nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
  " Search workspace symbols.
  nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
  " Do default action for next item.
  nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
  " Resume latest coc list.
  nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

  " Toggle diagnostics
  nmap <silent> <leader>g :call CocAction('diagnosticToggle')<CR>

  " To fix cursor disappear
  let g:coc_disable_transparent_cursor = 1

  " Coc highlight for lucius
  " Overwrite highlight after load lucius ColorScheme
  augroup CocHighlight
    au!
    autocmd ColorScheme * hi link CocErrorFloat ErrorMsg
    autocmd ColorScheme * hi link CocWarningFloat WarningMsg
    autocmd ColorScheme * hi link CocInfoFloat MoreMsg
    autocmd ColorScheme * hi link CocHintFloat Directory
  augroup END

  inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
  inoremap <silent><expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"
  nnoremap <silent><nowait> <C-i> :<C-u>CocCommand document.toggleInlayHint<cr>

  let g:coc_snippet_next = '<tab>'

  call configure#coc#add_extensions(['coc-snippets', 'coc-json'])

  " ft functions
  augroup coc_ft_functions
    autocmd!
    autocmd FileType rust call s:coc_ft_rust()
    autocmd FileType cpp call s:coc_ft_cpp()
    autocmd FileType go call s:coc_ft_go()
    autocmd FileType javascript,typescript call s:coc_ft_js_ts()
    autocmd FileType vue call s:coc_ft_vue()
    autocmd FileType python call s:coc_ft_python()
    autocmd FileType dart call s:coc_ft_dart()
  augroup END
endfunction

function! s:coc_ft_rust()
  call configure#coc#add_extensions(['coc-rust-analyzer'])
endfunction

function! s:coc_ft_cpp()
  call configure#coc#add_extensions(['coc-clangd'])

  nnoremap <silent><nowait> <space>^ :<C-u>CocCommand clangd.switchSourceHeader<cr>
endfunction

function! s:coc_ft_go()
  call configure#coc#add_extensions(['coc-go'])
endfunction

function! s:coc_ft_js_ts()
  call configure#coc#add_extensions(['coc-tsserver'])

  augroup coc_ft_js_ts
    autocmd!
    " Use this instead of coc.preferences.formatOnSaveFiletypes to avoid timeout
    " https://github.com/neoclide/coc.nvim/issues/3441
    autocmd BufWritePre *.ts,*.tsx silent :call CocAction('format')
  augroup end
endfunction

function! s:coc_ft_vue()
  call configure#coc#add_extensions(['@yaegassy/coc-volar'])
endfunction

function! s:coc_ft_python()
  call configure#coc#add_extensions(['coc-pyright'])
endfunction

function! s:coc_ft_dart()
  call configure#coc#add_extensions(['coc-flutter'])
endfunction
