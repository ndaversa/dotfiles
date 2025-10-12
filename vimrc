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
Plug 'itchyny/lightline.vim'
Plug 'lambdalisue/fern.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'kchmck/vim-coffee-script'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'airblade/vim-tailwind'
Plug 'ojroques/vim-oscyank'
Plug 'prettier/vim-prettier', { 'do': 'npm install' }
call plug#end() 

syntax enable       " Enable syntax highlighting
filetype plugin on  " Automatically detect filetype and load plugins

" Use solarized for syntax highlightling
let g:solarized_visibility = "high"
colorscheme solarized
set laststatus=2 "Needed for lightline.vim
let g:lightline = {'colorscheme': 'solarized'}

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

" clear the search buffer when hitting ;return
map <silent> <leader><cr> :noh<cr>

" toggle last buffer
nnoremap <leader><leader> <c-^>

" easier navigation between split windows
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" resize windows quickly using arrow keys
nnoremap <Right> :vertical resize +3<cr>
nnoremap <Left> :vertical resize -3<cr>
nnoremap <Up> :resize +3<cr>
nnoremap <Down> :resize -3<cr>
nnoremap <Bar> <c-w><Bar>
nnoremap = <c-w>=

" Turn backup off, since most stuff is in git anyway...
set nobackup
set nowb
set noswapfile

" Line numbers and scrolling
set number              " Enable line numbers
set relativenumber      " Show relative line numbers
set scrolljump=8        " Scroll 8 lines at a time at bottom/top
set scrolloff=3         " provide some context when editing

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
set wildmenu
set wildmode=list:longest,full

"" Undo
set hidden     " Allow backgrounding buffers without writing them, and remember marks/undo for backgrounded buffers
set undofile   " Maintain undo history between sessions
set undodir=~/.vim/undodir

" Fern, nerdtree replacement
nnoremap <leader>n :Fern . -drawer -toggle<CR> 

" CtrlP
let g:ctrlp_custom_ignore = 'node_modules'
let g:ctrlp_working_path_mode = 'rw'
let g:ctrlp_match_window_bottom = 1
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_dotfiles = 1 "so ctrlp won't search dotfiles/dotdirs
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_map = '<leader>f'
let g:ctrlp_regexp = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard | grep -v "node_modules"']

" Prettier
autocmd BufWritePre *.js,*.ts,*.json,*.html,*.css Prettier
nnoremap <leader>p :Prettier<CR>
nnoremap <leader>j :Prettier<CR>

" Send yanks and deletes using OSC52
augroup YankAndDeleteToOSC52
  autocmd!
  " Fire after yanks/deletes/changes that update a register
  autocmd TextYankPost * if exists(':OSCYank') && index(['y','d','c'], v:event.operator) >= 0 && v:event.regname !=# '_'
        \ | silent! OSCYank
        \ | endif
augroup END
