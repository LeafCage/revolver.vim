let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

function! Revolver#Mark(magazine) "{{{
  let save_crrbufnr = bufnr('%')
  let save_view = winsaveview()

  call s:__revolve_oldmarks(a:magazine)

  silent exe 'keepj b '. save_crrbufnr
  call winrestview(save_view)
  exe 'normal! m'. a:magazine[-1]
endfunction
"}}}

function! s:__revolve_oldmarks(magazine) "{{{
  let c = 0
  while c < len(a:magazine)-1
    try
      while c < len(a:magazine)-1
        silent exe 'keepj normal! `'. a:magazine[(c+1)]
        exe 'normal! m'. a:magazine[c]
        let c += 1
      endwhile
    catch /E20:/ "マークが設定されていなかった時
      let c += 1
    endtry
  endwhile
endfunction
"}}}










"=============================================================================
function! Revolver#Use_Register(magazine) "{{{
  let mode = mode()
  if mode =~ '[iRc]'
    return "\<C-r>". a:magazine[-1]
  else
    call feedkeys('"'. a:magazine[-1])
  endif
endfunction
"}}}



function! Revolver#Recording(magazine) "{{{
  call s:__revolve_oldreg(a:magazine)
  exe 'normal! q'. a:magazine[-1]
endfunction
"}}}

function! Revolver#Sence_unnamedRegChanging(magazine) "{{{
  exe 'if @'. a:magazine[-1]. ' ==# @"'
    return
  endif

  call s:__revolve_oldreg(a:magazine)
  exe 'let @'. a:magazine[-1]. ' = @"'
endfunction
"}}}

function! Revolver#Sence_namedRegChanging(magazine) "{{{
  exe 'if !exists("s:save_registr_". a:magazine[-1]) || @'. a:magazine[-1]. ' ==# s:save_registr_'. a:magazine[-1]
    return
  endif

  call s:__revolve_oldreg(a:magazine)
  exe 'let @'. a:magazine[-2]. ' = s:save_regst_'. a:magazine[-1]

  exe 'let s:save_registr_'. a:magazine[-1]. ' = @'. a:magazine[-1]
endfunction
"}}}



"-----------------------------------------------------------------------------
function! s:__revolve_oldreg(magazine) "{{{
  let magazine = a:magazine

  let c = 0
  while c < len(magazine)-1
    while c < len(magazine)-1
      exe 'let moreOldReg = @'. magazine[(c+1)]
      if empty(moreOldReg)
        let c += 1
        continue
      endif
      exe 'let @'. magazine[c]. '= moreOldReg'
      let c += 1
    endwhile
  endwhile
endfunction
"}}}





"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo

