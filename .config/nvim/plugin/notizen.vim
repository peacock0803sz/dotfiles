" function! s:reload_glance() abort
"   let s:filepath = expand('%:p')
"   if s:filepath !~# 'ddu\-.*\:'
"     echo 'Not a Notizen file, skipped.'
"   endif
" 
"   if exists('g:glance#server_port')
"     let s:glance#opend = system('lsof i:'.. s:glance#default_port)
"   else
"     let s:glance#opend = system('lsof i:8765')
"   endif
"   echo s:glance#opend
" endfunction
" 
" augroup AutoGlance
"   autocmd!
"   autocmd BufWinEnter *.md ++once call s:reload_glance()
" augroup END

function! s:open_notizen() abort
  let s:notizen_root = expand('$HOME/Documents/notizen')
  let s:_cwd = getcwd()
  if s:_cwd !=# s:notizen_root
    execute 'cd' .. s:notizen_root
    " echo s:_cwd .. ' is not the root directory of Notizen, switched to ' .. s:notizen_root
  endif

  call termopen(['./.devenv/state/venv/bin/sphinx-autobuild', '--no-initial', '--port', '8888', 'source', 'build'])
  :setlocal nonumber

  if system('hostname') =~? 'arpeggio.*'
    let s:working_dir = expand('$HOME/Documents/notizen/source/Work/GROOVE-X')
  else
    let s:working_dir = expand('$HOME/Documents/notizen/source/Private')
  endif
  execute 'cd' .. s:working_dir
  echo 'Switched to Notizen Workspace; ' .. s:working_dir

  :tabnew
endfunction

command! NotizenOpen call s:open_notizen()
