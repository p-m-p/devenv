call pathogen#infect()
syntax on
filetype plugin indent on

set t_Co=256
colorscheme xoria256

set guifont=Monaco:h12
set tabstop=2
set shiftwidth=2
set nocompatible
set number
set autoindent
set smartindent
set expandtab

" Cursor
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

" Highlight print margin
if version > 702
  highlight colorcolumn ctermbg=235
  set colorcolumn=80
endif

" Show nerd tree when running in GUI mode
if has("gui_running")
  set guioptions=egmrt
  autocmd vimenter * NERDTree
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endif
