let s:save_cpo = &cpo| set cpo&vim
"=============================================================================

"viminfoファイルが作られるpathを取得する
function! s:gs_viminfoPath() "{{{
  return substitute(&vi, '^.\{-1,}n', '', '')
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
