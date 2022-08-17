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
Plug 'svermeulen/vimpeccable'
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
Plug 'sainnhe/sonokai'
Plug 'nvim-lualine/lualine.nvim'
Plug 'akinsho/bufferline.nvim'

Plug 'vim-denops/denops.vim'
Plug 'skanehira/denops-docker.vim'

Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} 

Plug 'kien/rainbow_parentheses.vim'
Plug 'machakann/vim-sandwich'
Plug 'cohama/lexima.vim'
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
" autocmd User skkeleton-enable-pre let b:coc_suggest_disable = v:true
" autocmd User skkeleton-disable-pre let b:coc_suggest_disable = v:false
" }}}

" nvim-cmp {{{
set completeopt=menu,menuone,noselect

lua << EOS
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    window = {
      -- completion = cmp.config.window.bordered(),
      -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    capabilities = capabilities
  }
EOS


" nvim-lsp {{{
lua << EOS
  -- Mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  local opts = { noremap=true, silent=true }
  vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
  vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

  -- Use an on_attach function to only map the following keys
  -- after the language server attaches to the current buffer
  local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
  end

  local lsp_flags = {
    -- This is the default in Nvim 0.7+
    debounce_text_changes = 150,
  }
  require('lspconfig')['pyright'].setup{
      on_attach = on_attach,
      flags = lsp_flags,
  }
  require('lspconfig')['tsserver'].setup{
      on_attach = on_attach,
      flags = lsp_flags,
  }
  require('lspconfig')['rust_analyzer'].setup{
      on_attach = on_attach,
      flags = lsp_flags,
      -- Server-specific settings...
      settings = {
        ["rust-analyzer"] = {}
      }
  }
  require'lspconfig'.sumneko_lua.setup {
    settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = {'vim'},
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    },
  }
EOS
" }}}

" Mason {{{
lua << EOS
  require("mason").setup(
  require("mason-lspconfig").setup({
    ensure_installed = { "sumneko_lua", "rust_analyzer", "pyright" }
  })
EOS
" }}}

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

" Makefile {{{
augroup makefile
  autocmd!
  autocmd FileType make set expandtab&
  autocmd FileType make set shiftwidth&
  autocmd FileType make set shiftround&
  autocmd FileType make set smarttab&
  autocmd FileType make set softtabstop&
  autocmd FileType make set autoindent&
  autocmd FileType make set tabstop&
augroup END
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
