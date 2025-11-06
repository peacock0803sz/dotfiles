function! s:copy_path(target, range, line1, line2) abort
  " defaultはrelative path
  let expr = '%'
  if a:target == 'full path'
    let expr ..= ':p'
  elseif a:target == 'file name'
    let expr ..= ':t'
  endif

  let range_str = ''
  if a:range > 0
    if a:line1 == a:line2
      let range_str = '#L' .. a:line1
    else
      let range_str = '#L' .. a:line1 .. '-L' .. a:line2
    endif
  endif

  let result = expand(expr) .. range_str
  let @* = result
  echo 'Copy ' .. a:target .. ': ' .. result
endfunction
command! -range CopyFullPath     call s:copy_path('full path', <range>, <line1>, <line2>)
command! -range CopyFileName     call s:copy_path('file name', <range>, <line1>, <line2>)
command! -range CopyRelativePath call s:copy_path('relative path', <range>, <line1>, <line2>)
