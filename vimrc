runtime! archlinux.vim

set nocompatible

set background=dark
"colorscheme last256

syntax on
filetype plugin indent on

" show line numbers
set number
" highlight linenumbers in gray
highlight LineNr ctermfg=gray

" do not wrap lines
set nowrap

" set keys that wrap around lines
" <,>: arrow keys in normal/visual mode
" h,l: h and l keys
" [,]: arrow keys in insert mode
set whichwrap+=<,>,h,l,[,]
