
"idxポインタをサイクルさせる（末尾でループ）a:ascendingがサイクルさせる方向
function! s:gi_cycle_poi(_ascending, pointer, list_or_idxend) "{{{
  let idxend = type(a:list_or_idxend) ? len(a:list_or_idxend)-1 : a:list_or_idxend
  let idxpointer = a:_ascending ? a:pointer-1 : a:pointer+1
  if idxpointer < 0
    let idxpointer = idxend
  elseif idxpointer > idxend
    let idxpointer = 0
  endif
  return idxpointer
endfunction "}}}

