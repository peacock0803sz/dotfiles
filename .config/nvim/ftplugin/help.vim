scriptencoding utf-8
" if exists('b:did_ftplugin_after')
"   finish
" endif
" let b:did_ftplugin_after = 1

" SetUndoFtplugin delcommand HelpEdit | delcommand HelpView | set spell<
" SetUndoFtplugin nunmap <buffer> <C-n>
" SetUndoFtplugin nunmap <buffer> <C-p>

if &modifiable
  setlocal spell
endif
let &l:textwidth=78

" Thanks to thinca!
" Global
function! s:option_to_view()
  setlocal buftype=help nomodifiable readonly
  setlocal nolist
  if exists('+colorcolumn')
    setlocal colorcolumn=
  endif
  if has('conceal')
    setlocal conceallevel=2
  endif
endfunction

function! s:option_to_edit()
  setlocal buftype= modifiable noreadonly noexpandtab
  setlocal list textwidth=78
  if exists('+colorcolumn')
    setlocal colorcolumn=+1
  endif
  if has('conceal')
    setlocal conceallevel=0
  endif
endfunction

command! -buffer -bar HelpEdit call s:option_to_edit()
command! -buffer -bar HelpView call s:option_to_view()

function! s:resize()
  " Resize only when window isn't split vertically and there's one help
  " window.
  if (&l:textwidth * 2) <= winwidth(0) &&
        \ len(filter(range(1,winnr('$')),
        \ 'getwinvar(v:val,"&buftype")==#"help"')) == 1
    wincmd L
    execute 'vertical resize' (&l:textwidth+5)
  endif
endfunction

if &buftype ==# 'help'
  call s:resize()
  augroup vimrc_ftplugin_vim
      autocmd! BufWinEnter <buffer>
      autocmd BufWinEnter <buffer> call s:resize()
  augroup END
else
  " While editing only

  " SetUndoFtplugin silent! nunmap <C-]>
  " SetUndoFtplugin setlocal buftype< tabstop< textwidth<
  " SetUndoFtplugin setlocal conceallevel< expandtab< softtabstop<
  " SetUndoFtplugin delcommand GenerateContents
  " SetUndoFtplugin delcommand TOC

  command! -buffer -bar GenerateContents call s:generate_contents()
  command! -buffer -bar TOC call s:generate_contents()
  function! s:generate_contents()
    let cursor = getpos('.')

    let file_name = matchstr(expand('%:p:r:gs?\\?/?'), '.*/doc/\zs.*')
    let plug_name = substitute(file_name, '/', '-', 'g')
    let ja = expand('%:e') ==? 'jax'
    1

    if search('-contents\*$', 'W')
      silent .+1;/^=\{78}$/-1 delete _
      .-1
      put =''
    else
      keeppatterns /^License:\|Maintainer:/+1
      let caption = ja ? "目次" : 'CONTENTS'
      let tag = printf('*%s-contents*', plug_name)
      let tag_column = &l:textwidth - strdisplaywidth(tag)
      let tabcount = tag_column / &l:tabstop - strdisplaywidth(caption) / &l:tabstop
      let header = caption . repeat("\t", tabcount) . tag
      silent put =[repeat('=', &l:textwidth), header, '']
    endif

    let contents_pos = getpos('.')

    let captions = []
    while search('^\([=-]\)\1\{77}$', 'W')
      let prefix = getline('.') =~# '=' ? '' : '  '
      .+1
      let caption = matchlist(getline('.'), '^\(\%(\u\|-\| \)*\)\s\+\*\(\S*\)\*$')
      if !empty(caption)
        let caption = caption[1 : 2]
        let caption[0] = prefix . caption[0]
        call add(captions, caption)
      endif
    endwhile

    let max_tag_length = captions
          \->mapnew('strdisplaywidth(v:val[1])')
          \->max()
    let tag_column = &l:textwidth - max_tag_length
    let tag_column -= tag_column % &l:tabstop
    let lines = []
    for [title, tag] in captions
      let title_len = strdisplaywidth(title)
      if &l:expandtab
        let margin = repeat(' ', tag_column - title_len)
      else
        let charcount = tag_column / &l:tabstop - title_len / &l:tabstop
        let margin = repeat("\t", charcount)
      endif
      call add(lines, printf('%s%s|%s|', title, margin, tag))
    endfor

    call setpos('.', contents_pos)

    silent put =lines + repeat([''], 2)

    call setpos('.', cursor)
  endfunction

  function! s:get_text_on_cursor(pat)
    let line = getline('.')
    let pos = col('.')
    let s = 0
    while s < pos
      let [s, e] = [match(line, a:pat, s), matchend(line, a:pat, s)]
      if s < 0
        break
      elseif s < pos && pos <= e
        return line[s : e - 1]
      endif
      let s += 1
    endwhile
    return ''
  endfunction
endif

if !exists('*' .. expand('<SID>') .. 'search_link')
  function s:search_link(go_up) abort
    let l:SearchSkip = {->
          \ synID(line('.'), col('.'), 1)->synIDattr('name') !~#
          \ '\v^%(helpOption|helpHyperTextJump)$'}

    let flags = 'W'
    if a:go_up
      let flags ..= 'b'
    endif
    call search('[''|]\zs.', flags, 0, 0, l:SearchSkip)
  endfunction
endif

nnoremap <buffer> <C-p> <Cmd>call <SID>search_link(1)<CR>
nnoremap <buffer> <C-n> <Cmd>call <SID>search_link(0)<CR>
