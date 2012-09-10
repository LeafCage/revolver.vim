" Version : 1.0
" Author  : LeafCage <LeafCage+vim * gmail.com>
" License : MIT license

let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

"revolver mark "{{{
noremap <silent><Plug>(revolver-mark-local) :<C-u>call Revolver#Mark(0, g:revolver_mark_local_cylinder)<CR>
noremap <silent><Plug>(revolver-mark-global) :<C-u>call Revolver#Mark(0, g:revolver_mark_global_cylinder)<CR>
noremap <silent><Plug>(revolver-mark-local-typeB) :<C-u>call Revolver#Mark(1, g:revolver_mark_local_cylinder)<CR>
noremap <silent><Plug>(revolver-mark-global-typeB) :<C-u>call Revolver#Mark(1, g:revolver_mark_global_cylinder)<CR>
noremap <silent><Plug>(revolver-jump-last-local-mark) :<C-u>call Revolver#Jump(0, g:revolver_mark_local_cylinder)<CR>
noremap <silent><Plug>(revolver-jump-last-global-mark) :<C-u>call Revolver#Jump(1, g:revolver_mark_global_cylinder)<CR>

"viminfoファイルの大文字マークを抹消できるようにする（通常だと大文字マークは手動でしか消せない）
"fo=nのviminfoを削除してからviminfoをfo=nに書き出し
command! -nargs=+ -bang Delmarks    call <SID>Delmarks(<bang>, <args>)


let g:revolver_dir = exists('g:revolver_dir') ? g:revolver_dir : '~/.vim-revolver/'

if !exists('g:revolver_mark_local_cylinder')
  let g:revolver_mark_local_cylinder = 'abcdefghijklmnopqrstuvwxyz'
endif
if !exists('g:revolver_mark_global_cylinder')
  "let g:revolver_mark_global_cylinder = ['H', 'I', 'J', 'K', 'L', 'M']
  let g:revolver_mark_global_cylinder = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
endif


function! s:Delmarks(_all, marks) "{{{
  if empty(a:_all)
  endif
endfunction
"}}}
"}}}


"-----------------------------------------------------------------------------
"revolver register
"keymaps "{{{
noremap <silent><Plug>(revolver-register-recording)
  \ :<C-u>call Revolver#Recording(0, g:revolver_register_recording_cylinder)<CR>
noremap <silent><Plug>(revolver-register-recording-typeB)
  \ :<C-u>call Revolver#Recording(1, g:revolver_register_recording_cylinder)<CR>

noremap <silent><Plug>(revolver-register-add-recording)
  \ :<C-u>call Revolver#Add_Recording(g:revolver_register_recording_cylinder)<CR>
noremap <silent><Plug>(revolver-register-play-last-recording)
  \ :<C-u>call Revolver#Play(g:revolver_register_recording_cylinder)<CR>

noremap <silent><Plug>(revolver-register-usual)
  \ :<C-u>call Revolver#Use_Register(0, g:revolver_register_normal_cylinder)<CR>
inoremap <silent><expr><Plug>(revolver-register-usual)
  \ :<C-u>call Revolver#Use_Register(0, g:revolver_register_normal_cylinder)<CR>
cnoremap <silent><expr><Plug>(revolver-register-usual)
  \ :<C-u>call Revolver#Use_Register(0, g:revolver_register_normal_cylinder)<CR>

noremap <silent><Plug>(revolver-register-usual-typeB)
  \ :<C-u>call Revolver#Use_Register(1, g:revolver_register_normal_cylinder)<CR>
inoremap <silent><expr><Plug>(revolver-register-usual-typeB)
  \ :<C-u>call Revolver#Use_Register(1, g:revolver_register_normal_cylinder)<CR>
cnoremap <silent><expr><Plug>(revolver-register-usual-typeB)
  \ :<C-u>call Revolver#Use_Register(1, g:revolver_register_normal_cylinder)<CR>

noremap <silent><Plug>(revolver-register-conscious)
  \ :<C-u>call Revolver#Use_Register(0, g:revolver_register_conscious_cylinder)<CR>
inoremap <silent><expr><Plug>(revolver-register-conscious)
  \ :<C-u>call Revolver#Use_Register(0, g:revolver_register_conscious_cylinder)<CR>
cnoremap <silent><expr><Plug>(revolver-register-conscious)
  \ :<C-u>call Revolver#Use_Register(0, g:revolver_register_conscious_cylinder)<CR>
"}}}

if !exists('g:revolver_register_recording_cylinder')
  let g:revolver_register_recording_cylinder = "vwxyz"
endif
if !exists('g:revolver_register_normal_cylinder')
  let g:revolver_register_normal_cylinder = ['h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u']
endif
if !exists('g:revolver_register_conscious_cylinder')
  let g:revolver_register_conscious_cylinder = ['a', 'b', 'c', 'd', 'e', 'f', 'g']
endif



function! s:Make_CursorMoved_au() "{{{
  if !exists('g:revolver_register_enable_logging')
    return
  endif
  if g:revolver_register_enable_logging == 2
    aug revolver
      au!
      au CursorMoved * silent call Revolver#Sence_unnamedRegChanging(g:revolver_register_normal_cylinder)
      au CursorMoved * silent call Revolver#Sence_namedRegChanging(g:revolver_register_conscious_cylinder)
    aug END
  elseif g:revolver_register_enable_logging == 1
    aug revolver
      au!
      au CursorMoved * silent call Revolver#Sence_namedRegChanging(g:revolver_register_normal_cylinder)
      au CursorMoved * silent call Revolver#Sence_namedRegChanging(g:revolver_register_conscious_cylinder)
    aug END
  endif
endfunction
"}}}
call s:Make_CursorMoved_au()




"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo

