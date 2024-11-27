" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Setup plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'altercation/vim-colors-solarized'
call plug#end() 

syntax enable       " Enable syntax highlighting
filetype plugin on  " Automatically detect filetype and load plugins

" Use solarized for syntax highlightling
let g:solarized_visibility = "high"
colorscheme solarized

"" Mappings
let mapleader=";"

"Use hh,jj, or kk to <ESC>
inoremap hh <ESC>
inoremap jj <ESC>
inoremap kk <ESC>

"Disable <Esc> to undo muscle memory
inoremap <Esc> <CR>

"Enable repeat operation in visual mode
vnoremap . :norm.<CR>

" Map space to / (search) and c-space to ? (backgwards search)
map <space> /
map <c-space> ?

" Turn backup off, since most stuff is in git anyway...
set nobackup
set nowb
set noswapfile

" Line numbers and scrolling
set number              " Enable line numbers
set relativenumber      " Show relative line numbers
set scrolljump=8        " Scroll 8 lines at a time at bottom/top

"" Whitespace
set nowrap               " don't wrap lines
set tabstop=2            " a tab is two spaces
set shiftwidth=2         " an autoindent (with <<) is two spaces
set expandtab            " use spaces, not tabs
set backspace=indent,eol,start    " backspace through everything in insert mode

" This sends all yanks to the system clipboard (requires building vim with +clipboard support)
set clipboard=unnamed

set ruler          " show the cursor position all the time
set number         " show line numbers
set cursorline     " draw a line on the same as the cursor position
set mouse=a        " enable mouse support
set showcmd        " display incomplete commands
set title          " set the screen title to the currently opened file

"" Searching
set hlsearch       " highlight matches
set incsearch      " incremental searching
set ignorecase     " searches are case insensitive...
set smartcase      " ... unless they contain at least one capital letter
set cc=80          " set colorcolumn 80 to visualize 80th column
