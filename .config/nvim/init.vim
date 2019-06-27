"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/home/peacock/.vim/bundles/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('/home/peacock/.vim/bundles')
  call dein#begin('/home/peacock/.vim/bundles')

  " Let dein manage dein
  " Required:
  call dein#add('/home/peacock/.vim/bundles/repos/github.com/Shougo/dein.vim')

  " Add or remove your plugins here like this:
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')
  call dein#add('itchyny/lightline.vim')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable
let g:lightline = {'colorscheme': 'jellybeans','active': {'left': [[ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ]],'right': [[ 'lineinfo' ], [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ]]},'component': {'charvaluehex': '0x%B'},}

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
