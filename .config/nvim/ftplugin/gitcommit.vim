augroup GitCommitMR
  autocmd! BufEnter * call mr#mru#delete(expand("<cfile>"))
  autocmd! BufEnter * call mr#mrw#delete(expand("<cfile>"))
  autocmd! BufEnter * call mr#mrr#delete(expand("<cfile>"))
  autocmd! BufEnter * call mr#mrd#delete(expand("<cfile>"))
augroup END
