function! s:open_notizen() abort
  let s:notizen_root = expand('$HOME/Documents/notizen')
  let s:_cwd = getcwd()
  if s:_cwd !=# s:notizen_root
    execute 'cd' .. s:notizen_root
    " echo s:_cwd .. ' is not the root directory of Notizen, switched to ' .. s:notizen_root
  endif

  call termopen(['uv', 'run', 'make', 'livehtml', 'PORT=8080'])
  :setlocal nonumber

  if system('hostname') =~? 'toccata.*'
    let s:working_dir = expand('$HOME/Documents/notizen/source/Work/TOPGATE')
  else
    let s:working_dir = expand('$HOME/Documents/notizen/source/Private')
  endif
  execute 'cd' .. s:working_dir
  echo 'Switched to Notizen Workspace; ' .. s:working_dir

  :tabnew
endfunction

command! NotizenOpen call s:open_notizen()