let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

"revolver mark "{{{
noremap <silent><Plug>(revolver-mark-local) :<C-u>call Revolver#Mark(g:revolver_mark_local_magazine)<CR>
noremap <silent><Plug>(revolver-mark-global) :<C-u>call Revolver#Mark(g:revolver_mark_global_magazine)<CR>

"viminfoファイルの大文字マークを抹消できるようにする（通常だと大文字マークは手動でしか消せない）
"fo=nのviminfoを削除してからviminfoをfo=nに書き出し
command! -nargs=+ -bang Delmarks    call <SID>Delmarks(<bang>, <args>)


if !exists('g:revolver_mark_local_magazine')
  let g:revolver_mark_local_magazine = ['h', 'i', 'j', 'k', 'l', 'm']
endif
if !exists('g:revolver_mark_global_magazine')
  let g:revolver_mark_global_magazine = ['H', 'I', 'J', 'K', 'L', 'M']
endif


function! s:Delmarks(_all, marks) "{{{
  if empty(a:_all)
  endif
endfunction
"}}}
"}}}

"revolver register
"keymaps "{{{
noremap <silent><Plug>(revolver-register-recording) :<C-u>call Revolver#Recording(g:revolver_register_recording_magazine)<CR>

noremap <silent><Plug>(revolver-register-usual) :<C-u>call Revolver#Use_Register(g:revolver_register_normal_magazine)<CR>
inoremap <silent><expr><Plug>(revolver-register-usual) :<C-u>call Revolver#Use_Register(g:revolver_register_normal_magazine)<CR>
cnoremap <silent><expr><Plug>(revolver-register-usual) :<C-u>call Revolver#Use_Register(g:revolver_register_normal_magazine)<CR>

noremap <silent><Plug>(revolver-register-conscious) :<C-u>call Revolver#Use_Register(g:revolver_register_conscious_magazine)<CR>
inoremap <silent><expr><Plug>(revolver-register-conscious) :<C-u>call Revolver#Use_Register(g:revolver_register_conscious_magazine)<CR>
cnoremap <silent><expr><Plug>(revolver-register-conscious) :<C-u>call Revolver#Use_Register(g:revolver_register_conscious_magazine)<CR>
"}}}
  nmap <C-k>h <Plug>(revolver-register-usual)

if !exists('g:revolver_register_normal_magazine')
  let g:revolver_register_normal_magazine = reverse(['h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u'])
endif
if !exists('g:revolver_register_conscious_magazine')
  let g:revolver_register_conscious_magazine = reverse(['a', 'b', 'c', 'd', 'e', 'f', 'g'])
endif
if !exists('g:revolver_register_recording_magazine')
  let g:revolver_register_recording_magazine = reverse(['v', 'w', 'x', 'y', 'z'])
endif



function! s:Make_CursorMoved_au() "{{{
  if exists('g:revolver_register_enable_logging') && g:revolver_register_enable_logging == 2
    aug revolver
      au!
      au CursorMoved * silent call Revolver#Sence_unnamedRegChanging(g:revolver_register_normal_magazine)
      au CursorMoved * silent call Revolver#Sence_namedRegChanging(g:revolver_register_conscious_magazine)
    aug END
  elseif exists('g:revolver_register_enable_logging') && g:revolver_register_enable_logging == 1
    aug revolver
      au!
      au CursorMoved * silent call Revolver#Sence_namedRegChanging(g:revolver_register_normal_magazine)
      au CursorMoved * silent call Revolver#Sence_namedRegChanging(g:revolver_register_conscious_magazine)
    aug END
  endif
endfunction
"}}}
call s:Make_CursorMoved_au()




"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo

