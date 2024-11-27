" Install vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Setup plugins
call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'altercation/vim-colors-solarized'
call plug#end() 

" Enable syntax highlighting
syntax enable

" Automatically detect filetype and load plugins
filetype plugin on

" In insert mode map a double-j to the esc key
inoremap jj <Esc>

" Use solarized for syntax highlightling
let g:solarized_visibility = "high"
colorscheme solarized
