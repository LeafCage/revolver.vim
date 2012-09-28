let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:V = vital#of('revolver')
let s:LL = s:V.import('Lclib.List')
let s:LV = s:V.import('Lclib.Vim')

"-----------------------------------------------------------------------------
"Actions

function! Revolver#Mark(_typeB, cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  if s:__verify_mark_cylinder(cylinder)
    echoerr 'Revolver: 大文字と小文字のマークを混ぜないでください'
    return
  endif
  if a:_typeB
    call s:__mark_typeB(cylinder)
  else
    call s:__mark_typeA(cylinder)
  endif
endfunction
"}}}

function! s:__verify_mark_cylinder(cylinder) "{{{
  let caseType = a:cylinder[0] =~# '\u' ? '\u' : '\l'
  for pkdcase in a:cylinder
    if pkdcase !~# caseType
      return 1
    endif
  endfor
endfunction
"}}}


function! Revolver#Jump(_global, cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  let d = fnamemodify(g:revolver_dir. 'marks/', ':p')
  if a:_global
    call s:__jump_by_var6idxfile('g:revolver_mark_idx', 'globar_mark_idx', d, cylinder)
  else
    let crrb_NN = substitute(substitute(expand('%:p'), ':', '=-', 'g'), '[/\\]', '=+', 'g')
    call s:__jump_by_var6idxfile('b:local_mark_idx', crrb_NN, d, cylinder)
  endif
endfunction
"}}}

function! s:__jump_by_var6idxfile(varname, idxfilename, d, cylinder) "{{{
  if exists(a:varname)
    exe 'let char = a:cylinder['. a:varname. ']'
    exe 'normal! `'. char
    echo 'Revolver: jump to "'. char. '"'
  elseif filereadable(a:d. a:idxfilename)
    exe 'let '. a:varname. ' = readfile(a:d. a:idxfilename)[0]'
    exe 'let char = a:cylinder['. a:varname. ']'
    exe 'normal! `'. char
    echo 'Revolver: jump to "'. char. '"'
  else
    echo 'Revolver: No marks'
  endif
endfunction
"}}}


function! Revolver#Delmarks(_all, ...) "{{{
  let marks = ''
  if a:0
    for pkd in a:000
      let marks .= type(pkd)==type('') ? pkd : join(pkd, '')
    endfor
  endif
  if !empty(a:_all) "{{{
    let g = type(g:revolver_mark_global_cylinder)==type('') ? g:revolver_mark_global_cylinder : join(g:revolver_mark_global_cylinder, '')
    let l = type(g:revolver_mark_local_cylinder)==type('') ? g:revolver_mark_local_cylinder : join(g:revolver_mark_global_cylinder, '')
    let marks .= g . l

    call Revolver#Reset_typeB_counter(1)
    call Revolver#Reset_typeB_counter(0)
  endif"}}}
  if empty(marks)
    return
  endif

  let viminfoPath = fnamemodify(expand(s:LV.gs_viminfoPath()), ':p')
  if !empty(viminfoPath)
    call delete(viminfoPath)
  elseif !empty(&vi)
    call delete(fnamemodify(expand('~/_viminfo'), ':p'))
  endif

  exe 'delmarks '. marks
  if !empty(viminfoPath) || !empty(&vi)
    wviminfo
  endif
endfunction
"}}}


function! Revolver#Reset_typeB_counter(_global) "{{{
  let d = fnamemodify(g:revolver_dir, ':p')
  if a:_global
    if exists('g:revolver_mark_idx')
      unlet g:revolver_mark_idx
    endif
    call delete(d. 'global_mark_idx')
  else
    if exists('b:local_mark_idx')
      unlet b:local_mark_idx
    endif
    let crrb_NN = substitute(substitute(expand('%:p'), ':', '=-', 'g'), '[/\\]', '=+', 'g')
    call delete(d. 'marks/'. crrb_NN)
  endif
endfunction
"}}}



"=============================================================================
"subroutine

"-----------------------------------------------------------------------------
function! s:__mark_typeA(cylinder) "{{{
  let save_crrbufnr = bufnr('%')
  let save_view = winsaveview()

  call s:___revolve_oldmarks(a:cylinder)

  silent exe 'keepj b '. save_crrbufnr
  call winrestview(save_view)
  exe 'normal! m'. a:cylinder[0]
endfunction
"}}}

function! s:___revolve_oldmarks(cylinder) "{{{
  let c = len(a:cylinder)-1
  while c > 0
    try
      while c > 0
        silent exe 'keepj normal! `'. a:cylinder[(c-1)]
        exe 'normal! m'. a:cylinder[c]
        let c -= 1
      endwhile
    catch /E20:/ "マークが設定されていなかった時
      let c -= 1
    endtry
  endwhile
endfunction
"}}}

"-----------------------------------------------------------------------------
function! s:__mark_typeB(cylinder) "{{{
  if a:cylinder[0] =~# '\u'
    call s:___uppercaseMark(a:cylinder)
  else
    call s:___lowercaseMark(a:cylinder)
  endif
endfunction
"}}}

function! s:___lowercaseMark(cylinder) "{{{
  let d = s:_make_revolverDir()
  let crrb_NN = substitute(substitute(expand('%:p'), ':', '=-', 'g'), '[/\\]', '=+', 'g')
  call s:_cycle8writefile_typeBidx('b:local_mark_idx', d.'marks/', crrb_NN, a:cylinder)

  exe 'normal! m'. a:cylinder[b:local_mark_idx]
  echo 'Revolver: marked "'. a:cylinder[b:local_mark_idx]. '"'
endfunction
"}}}

function! s:___uppercaseMark(cylinder) "{{{
  let d = fnamemodify(g:revolver_dir, ':p')
  let d = s:_make_revolverDir()
  call s:_cycle8writefile_typeBidx('g:revolver_mark_idx', d, 'global_mark_idx', a:cylinder)

  exe 'normal! m'. a:cylinder[g:revolver_mark_idx]
  echo 'Revolver: marked "'. a:cylinder[g:revolver_mark_idx]. '"'
endfunction
"}}}











"=============================================================================
function! Revolver#Recording(_typeB, cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  if a:_typeB
    call s:__recording_typeB(cylinder)
  else
    call s:__revolve_oldreg(cylinder)
    echo 'Revolver: using "'. cylinder[0]. '"'
    exe 'normal! q'. cylinder[0]
  endif
endfunction
"}}}

function! s:__recording_typeB(cylinder) "{{{
  let d = s:_make_revolverDir()
  call s:_cycle8writefile_typeBidx('g:revolver_recording_char', d, 'recording_idx', a:cylinder)

  exe 'normal! q'. a:cylinder[g:revolver_recording_char]
  echo 'Revolver: using "'. a:cylinder[g:revolver_recording_char]. '"'
endfunction
"}}}


function! Revolver#Add_Recording(cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  if s:_chkerr__exists_recording()
    return
  endif
  let char = toupper(cylinder[g:revolver_recording_char])
  exe 'normal! q'. char
  echo 'Revolver: using "'. char. '"'
endfunction
"}}}

function! Revolver#Play(cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  if s:_chkerr__exists_recording()
    return
  endif
  exe 'normal! '. v:count1. '@'. cylinder[g:revolver_recording_char]
endfunction
"}}}

"-----------------------------------------------------------------------------
function! Revolver#Use_Register(_typeB, cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  if a:_typeB
    call s:__use_register_typeB(cylinder)
  else
    let mode = mode()
    if mode =~ '[iRc]'
      return "\<C-r>". cylinder[0]
    else
      call feedkeys('"'. cylinder[0])
    endif
  endif
endfunction
"}}}

function! s:__use_register_typeB(cylinder) "{{{
  let d = s:_make_revolverDir()
  call s:_cycle8writefile_typeBidx('g:revolver_usual_reg', d, 'usual_reg_idx', a:cylinder)

  let mode = mode()
  if mode =~ '[iRc]'
    return "\<C-r>". a:cylinder[g:revolver_usual_reg]
  else
    call feedkeys('"'. a:cylinder[g:revolver_usual_reg])
  endif
endfunction
"}}}

"-----------------------------------------------------------------------------

function! Revolver#Sence_unnamedRegChanging(cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  exe 'if @'. cylinder[0]. ' ==# @"'
    return
  endif

  call s:__revolve_oldreg(cylinder)
  exe 'let @'. cylinder[0]. ' = @"'
endfunction
"}}}

function! Revolver#Sence_namedRegChanging(cylinder) "{{{
  let cylinder = type(a:cylinder)==type('')? s:_str2list(a:cylinder) : a:cylinder
  exe 'if !exists("s:save_registr_". cylinder[0]) || @'. cylinder[0]. ' ==# s:save_registr_'. cylinder[0]
    return
  endif

  call s:__revolve_oldreg(cylinder)
  exe 'let @'. cylinder[1]. ' = s:save_regst_'. cylinder[0]

  exe 'let s:save_registr_'. cylinder[0]. ' = @'. cylinder[0]
endfunction
"}}}



"-----------------------------------------------------------------------------
function! s:__revolve_oldreg(cylinder) "{{{
  let c = len(a:cylinder)-1
  while c > 0
    while c > 0
      exe 'let moreOldReg = @'. a:cylinder[(c-1)]
      if empty(moreOldReg)
        let c -= 1
        continue
      endif
      exe 'let @'. a:cylinder[c]. '= moreOldReg'
      let c -= 1
    endwhile
  endwhile
endfunction
"}}}



"=============================================================================
function! s:_str2list(cylinder) "{{{
  return split(a:cylinder, '\zs')
endfunction
"}}}

function! s:_make_revolverDir() "{{{
  let d = fnamemodify(g:revolver_dir, ':p')
  if !isdirectory(d)
    call mkdir(d, 'p')
  endif
  return d
endfunction
"}}}

function! s:_cycle8writefile_typeBidx(varname, d, idxfilename, cylinder) "{{{
  if !exists(a:varname)
    if filereadable(a:d. a:idxfilename)
      exe 'let '. a:varname. ' = readfile("'. a:d. a:idxfilename. '")[0]'
    else
      exe 'let '. a:varname. ' = -1'
    endif
  endif

  exe 'let '. a:varname. ' = s:LL.gi_cycle_poi(0, '. a:varname. ', a:cylinder)'
  exe 'call writefile(['. a:varname. '], "'. a:d. a:idxfilename. '")'
endfunction
"}}}

function! s:_chkerr__exists_recording() "{{{
  if !exists('g:revolver_recording_char')
    let f = fnamemodify(g:revolver_dir, ':p'). 'recording_idx'
    if filereadable(f)
      let g:revolver_recording_char = readfile(f)[0]
    else
      echo 'Revolver: no recording'
      return 1
    endif
  endif
endfunction
"}}}
"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo

