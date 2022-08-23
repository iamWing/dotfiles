" Load plugins
packadd! onedark.vim

" Set 24-bit (true-colour) mode if available
if (!empty($COLORTERM) && empty($TMUX))
  if (has("termguicolors"))
    set termguicolors
  endif
endif

syntax on               " enable syntax highlighting
colorscheme onedark     " set `desert` as default colour scheme
set autoindent          " indent when moving to the next while writing code
set colorcolumn=80      " show 80 line indicator
set encoding=utf-8      " show output in UTF-8 as YouCompleteMe requires
set expandtab           " expand tabs into spaces
set fileencoding=utf-8  " save file with UTF-8 encoding
set fileformat=unix     " save file with LF line endings
set number              " show line numbers
set shiftwidth=4        " shift lines by 4 spaces for indent
set showmatch           " show the matching part of the pair for [] {} & ()
set softtabstop=4       " for easier backspacing the soft tabs
set tabstop=4           " set tabs to have 4 spaces
set tws=20x0            " set terminal windows size

" split layout
set splitbelow
set splitright

" split navigations
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-w><C-L>
nnoremap <C-H> <C-W><C-H>

" highlight unneccessary whitespaces
highlight BadWhitespace ctermbg=yellow guibg=yellow
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match
  \ BadWhitespace /\s\+$/

au BufEnter * if &ft == '' | setlocal colorcolumn=

set backspace=indent,eol,start
