filetype off
filetype plugin indent off

" display
set colorcolumn=88,100
set number
set signcolumn=yes
set clipboard+=unnamedplus
set pumblend=30
set ambiwidth=single
syntax enable
set mouse=a
" }}}

" indent {{{
set expandtab
set shiftround
set shiftwidth=2
" set smartindent
set smarttab
set softtabstop=0
set autoindent
set tabstop=2
" }}}


" c-mode maps {{{
cnoremap <C-a> <Home>
cnoremap <C-b> <Left>
cnoremap <C-e> <End>
cnoremap <C-f> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>
" }}}

" scroll maps {{{
map <ScrollWheelUp> <C-Y>
map <ScrollWheelDown> <C-E>


" tab setting {{{
set showtabline=2
nnoremap [TABCMD]  <nop>
nmap     <leader>t [TABCMD]
nnoremap <silent> [TABCMD]f :<c-u>tabfirst<cr>
nnoremap <silent> [TABCMD]l :<c-u>tablast<cr>
nnoremap <silent> [TABCMD]n :<c-u>tabnext<cr>
nnoremap <silent> [TABCMD]N :<c-u>tabNext<cr>
nnoremap <silent> [TABCMD]p :<c-u>tabprevious<cr>
nnoremap <silent> [TABCMD]e :<c-u>tabedit<cr>
nnoremap <silent> [TABCMD]w :<c-u>tabclose<cr>
nnoremap <silent> [TABCMD]o :<c-u>tabonly<cr>
nnoremap <silent> [TABCMD]c :<c-u>tabs<cr>
nnoremap <silent> [TABCMD]s :<c-u>tabnew<cr>
" }}}

" {{{ Plugins
call plug#begin('~/.vim/plugged')
Plug 'vim-jp/vimdoc-ja'

Plug 'kyazdani42/nvim-web-devicons'
Plug 'lambdalisue/nerdfont.vim'
Plug 'nvim-lua/plenary.nvim'

Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'sainnhe/sonokai'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'

Plug 'vim-denops/denops.vim'
Plug 'skanehira/denops-docker.vim'

Plug 'neoclide/coc.nvim', { 'merged': 0, 'branch': 'release' } 
Plug 'dccsillag/magma-nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 

Plug 'kien/rainbow_parentheses.vim'
Plug 'machakann/vim-sandwich'
Plug 'cohama/lexima.vim'
Plug 'yuki-yano/fuzzy-motion.vim'
Plug 'monaqa/dial.nvim'
Plug 'lambdalisue/suda.vim'

Plug 'rhysd/committia.vim'
Plug 'lambdalisue/gina.vim'
Plug 'lewis6991/gitsigns.nvim'

Plug 'vim-test/vim-test'

Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'yuki-yano/fern-preview.vim'

Plug 'vim-skk/skkeleton'

Plug 'thinca/vim-quickrun'
Plug 'folke/which-key.nvim'

call plug#end()
" }}}

" statusline {{{
lua << EOF
require'lualine'.setup {
  options = {
    icons_enabled = true,
    theme = 'sonokai',
    component_separators = { left = '|', right = '|'},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {},
    always_divide_middle = true,
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {
      'branch', 
      {
        'diff',
        colored = true,
        diff_color = {
          added    = {fg = '#9ece6a'},
          modified = {fg = '#e0af68'},
          removed  = {fg = '#db4b4b'},
        },
        symbols={added='+', modified='~', removed='-'},
      },
    },
    lualine_c = {'diagnostics'},
    lualine_x = {'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  extensions = {}
}
EOF
" }}} statusline

" {{ tabline
" lua << EOF
" require('bufferline').setup {
"   name_formatter = 'path',
" }
" EOF
" }}

" {{{ ColorScheme
set termguicolors

let g:sonokai_style = 'andromeda'
let g:sonokai_disable_italic_comment = 1
colorscheme sonokai
" }}}

" treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = {"python", "javascript", "vue", "rust"},
  highlight = {
    enable = true,
  }
}
EOF
" }}}

" {{{ which-key
lua << EOF
require('which-key').setup{}
EOF

nnoremap <leader>? :WhichKey <CR>
inoremap <c-?> :WhichKey i <CR>
" }}}


" {{{ skkeleton
imap <C-j> <Plug>(skkeleton-toggle)
cmap <C-j> <Plug>(skkeleton-toggle)
call skkeleton#config({
\ 'eggLikeNewline': v:true,
\ 'showCandidatesCount': 3,
\ 'globalJisyo': '~/ghq/github.com/skk-dev/dict/SKK-JISYO.L'
\ })
" call skkeleton#register_kanatable('rom', {
" \ "z\<Space>": ["\u3000", ''],
" \ })
" }
autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
" }}}

" {{{ Coc global extensions
let g:coc_global_extensions = [
  \ 'coc-actions',
  \ 'coc-calc',
  \ 'coc-css',
  \ 'coc-deno',
  \ 'coc-diagnostic',
  \ 'coc-docker',
  \ 'coc-eslint',
  \ 'coc-fzf-preview',
  \ 'coc-go',
  \ 'coc-html',
  \ 'coc-htmldjango',
  \ 'coc-json',
  \ 'coc-lua',
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-pyright',
  \ 'coc-rust-analyzer',
  \ 'coc-snippets',
  \ 'coc-sh',
  \ 'coc-stylelint',
  \ 'coc-sh',
  \ 'coc-tag',
  \ 'coc-tsserver',
  \ 'coc-vetur',
  \ 'coc-vimlsp',
  \ 'coc-word',
  \ 'coc-yaml'
\ ]
" }}}

" Coc Settings {{{

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm(): "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>fo  <Plug>(coc-format-selected)
" nmap <leader>fo  <Plug>(coc-format-selected)

xmap <leader>FO <Plug>(coc-format)
nmap <leader>FO <Plug>(coc-format)


augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
" Note coc#float#scroll works on neovim >= 0.4.0 or vim >= 8.2.0750
nnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
nnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
inoremap <nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

" NeoVim-only mapping for visual mode scroll
" Useful on signatureHelp after jump placeholder of snippet expansion
if has('nvim')
  vnoremap <nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#nvim_scroll(1, 1) : "\<C-f>"
  vnoremap <nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#nvim_scroll(0, 1) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" }}}

" magma-nvim {{{
nnoremap <silent><expr> <Leader>j        :MagmaEvaluateOperator<CR>
nnoremap <silent>       <Leader>jl       :MagmaEvaluateLine<CR>
xnoremap <silent>       <Leader>j<Enter> :<C-u>MagmaEvaluateVisual<CR>
nnoremap <silent>       <Leader>jc       :MagmaReevaluateCell<CR>
nnoremap <silent>       <Leader>jd       :MagmaDelete<CR>
nnoremap <silent>       <Leader>jo       :MagmaShowOutput<CR>

let g:magma_automatically_open_output = v:true
" }}}

let g:test#python#runner = 'pytest'

let g:sandwich#recipes = deepcopy(g:sandwich#default_recipes)


" dial.nvim {{{
nnoremap <C-+> <Plug>(dial-increment)
nnoremap <C--> <Plug>(dial-decrement)
xnoremap <C-+> <Plug>(dial-increment)
xnoremap <C--> <Plug>(dial-decrement)
" }}}

" fern {{{
let g:fern#renderer = "nerdfont"

nnoremap <Leader>fe :<C-u>Fern -drawer .<CR>
augroup fern-signcolumn
  autocmd!
  autocmd FileType fern set signcolumn=no
  autocmd FileType fern set nonumber
augroup END
" }}}


" fzf-preview {{{
nmap <Leader>f [fzf-p]
xmap <Leader>f [fzf-p]

nnoremap <silent> [fzf-p]p     :<C-u>CocCommand fzf-preview.FromResources project_mru git<CR>
nnoremap <silent> [fzf-p]gs    :<C-u>CocCommand fzf-preview.GitStatus<CR>
nnoremap <silent> [fzf-p]ga    :<C-u>CocCommand fzf-preview.GitActions<CR>
nnoremap <silent> [fzf-p]b     :<C-u>CocCommand fzf-preview.Buffers<CR>
nnoremap <silent> [fzf-p]B     :<C-u>CocCommand fzf-preview.AllBuffers<CR>
nnoremap <silent> [fzf-p]o     :<C-u>CocCommand fzf-preview.FromResources buffer project_mru<CR>
nnoremap <silent> [fzf-p]<C-o> :<C-u>CocCommand fzf-preview.Jumps<CR>
nnoremap <silent> [fzf-p]g;    :<C-u>CocCommand fzf-preview.Changes<CR>
nnoremap <silent> [fzf-p]/     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'"<CR>
nnoremap <silent> [fzf-p]*     :<C-u>CocCommand fzf-preview.Lines --add-fzf-arg=--no-sort --add-fzf-arg=--query="'<C-r>=expand('<cword>')<CR>"<CR>
nnoremap          [fzf-p]gr    :<C-u>CocCommand fzf-preview.ProjectGrep<Space>
xnoremap          [fzf-p]gr    "sy:CocCommand   fzf-preview.ProjectGrep<Space>-F<Space>"<C-r>=substitute(substitute(@s, '\n', '', 'g'), '/', '\\/', 'g')<CR>"
nnoremap <silent> [fzf-p]t     :<C-u>CocCommand fzf-preview.BufferTags<CR>
nnoremap <silent> [fzf-p]q     :<C-u>CocCommand fzf-preview.QuickFix<CR>
nnoremap <silent> [fzf-p]l     :<C-u>CocCommand fzf-preview.LocationList<CR>
" }}}

" committia {{{
let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
  " Additional settings
  setlocal spell

  " If no commit message, start with insert mode
  if a:info.vcs ==# 'git' && getline(1) ==# ''
    startinsert
  endif

  " Scroll the diff window from insert mode
  " Map <C-n> and <C-p>
  imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
  imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)
endfunction

augroup plugin-committia
  autocmd!
  autocmd BufReadPost COMMIT_EDITMSG,MERGE_MSG if s:should_open('gitcommit') | call committia#open('git') | endif
  autocmd BufEnter gina-commit call committia#open('git')
augroup END
" }}}

" {{{ gitsign

lua << EOF
require('gitsigns').setup {
  --
}
EOF
" }}}

" {{{ vue.js
autocmd BufEnter,BufRead *.njk set filetype=django
" }}}

" transparents {{{
highlight Normal ctermbg=NONE guibg=NONE
highlight NonText ctermbg=NONE guibg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight SpecialKey ctermbg=NONE guibg=NONE
highlight EndOfBuffer ctermbg=NONE guibg=NONE
" }}}

" F**K Conceal!!!
 autocmd Filetype json setl conceallevel=0
