set nocompatible
filetype plugin indent on
syntax enable

set number
set relativenumber
set signcolumn=yes
set mouse=a
set showmode
set clipboard=unnamedplus
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smartindent
set autoindent
set nowrap
set breakindent
set ignorecase
set smartcase
set incsearch
set completeopt=menu,menuone,noselect
set splitright
set splitbelow
set updatetime=250
set timeoutlen=400
set scrolloff=6
set sidescrolloff=8
set cursorline
set list
set listchars=tab:»\ ,trail:•,nbsp:␣,lead:·
set undofile
set undolevels=10000
set noswapfile
set nobackup
set spelllang=en
set wildmenu
set wildmode=longest:full,full
set backspace=indent,eol,start

let mapleader = " "

nnoremap <leader>ww :w<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>qq :qa<CR>
nnoremap <leader>bd :bd<CR>
nnoremap <leader>wh :sp<CR>
nnoremap <leader>wv :vsp<CR>
nnoremap <leader>wd :q<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
xnoremap J :m '>+1<CR>gv=gv
xnoremap K :m '<-2<CR>gv=gv
