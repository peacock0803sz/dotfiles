let g:reading_vimrc_wincmd = 'T'

augroup ReadingVimrcWincmd
  autocmd!
  autocmd BufWinEnter * if bufname('%') =~# '^readingvimrc://'
        \|   execute 'wincmd' g:reading_vimrc_wincmd
        \| endif
augroup END

" from: https://github.com/Omochice/dotfiles/blob/1a13cd48e93280b9dfa3594be3f4270605eebb21/config/nvim/rc/lazy.toml#L266-L275
function! s:reading_copy(line1, line2) abort
  " NOTE: 4 is ['next', {owner}, {repo}, {branch}]
  const l:file = expand('%')->substitute('readingvimrc://\([^/]\{1,\}/\)\{4\}', '', '')
  const l:line = a:line1 == a:line2 ? printf('L%d', a:line1) : printf('L%d+%d', a:line1, a:line2 - a:line1)
  call setreg(v:register, input('', printf('%s#%s ', l:file, l:line)))
endfunction
command! -range ReadingVimrcCopy call <SID>reading_copy(<line1>, <line2>)
