"

"Don't act like old guy vi, give me the features of vim
set nocp

let vundle_readme=expand('~/.vim/bundle/vundle/README.md')
if filereadable(vundle_readme)
    filetype off                   " required!

    set rtp+=C:\Users\Sundar\vimfiles/bundle/vundle/
    call vundle#rc()

    " let Vundle manage Vundle
    " required! 
    Bundle 'gmarik/vundle'

    Bundle 'vim-scripts/perl-support.vim'
    Bundle 'vim-scripts/compview.git'
    "Bundle 'c9s/perlomni.vim' Doesn't work on Windows, needs piping and some Unix commands
    Bundle 'perl_search_lib'
    Bundle 'tpope/vim-surround.git'
    Bundle 'tpope/vim-repeat.git'
    Bundle 'matchit.zip'
    Bundle 'godlygeek/tabular'
    Bundle 'mattn/zencoding-vim'
endif

if !has("gui_running")
    "For colors
    set term=xtermc
endif

"Syntax highlighting
syntax on

"search for tags in current dir, then upwards
set tags=./tags;/,tags;/

set autoindent
"Indent automatically according to filetype
filetype plugin indent on

let perl_include_pod   = 1    "include pod.vim syntax file with perl.vim
let perl_extended_vars = 1    "highlight complex expressions such as @{[$x, $y]}
let perl_sync_dist     = 250  "use more context for highlighting

""" MAPPINGS
"" Normal Mode Mappings

nnoremap <Leader>pm :call PerlModuleUnderCursor()<CR>

function! PerlModuleUnderCursor()
  execute 'e `perldoc -lm ' . expand("<cWORD>") . '`'
endfunction
let g:Perl_PerlTags = 'on' "Supposed to do the same as above with Ctrl-] if Perl::Tags installed

"F6 switches windows
map <F6> <C-W>p
"Make F6 work in insert mode too
imap <F6> <ESC><F6>

"Ctrl Tab and Ctrl Shift Tab for buffer switching
map <C-Tab> :bn<CR>
map <C-S-Tab> :bp<CR>

"F11 for fullscreen
nnoremap <F11> <ESC>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR> 
inoremap <F11> <ESC>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR> 

"- saves
map - :up<CR>

"" Filetype Specific Mappings
" Show help for current word when F4 is pressed
autocmd FileType python map <F4> :execute 'let cw=expand("<cword>")' \| vnew \| execute "r!pydoc " cw<CR>
autocmd FileType python imap <F4> <ESC><F4>
let python_highlight_all = 1

"Switch 0 and ^ since we most often want to go to start of text rather than 
"line itself, and 0 is much easier to type
nnoremap 0 ^
nnoremap ^ 0

"" Insert Mode Mappings
"Make F2 save insert mode, and take me back to insert mode
imap <F2> <ESC>-a

"Control-<navigation character> to move in insert mode
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

"Ctrl space for omni-complete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

vmap aa :Align=<CR>

""" End of MAPPINGS

"Enable omnicomplete
set omnifunc=syntaxcomplete#Complete

" Avoid creating temporary files in source directories
if ! isdirectory($HOME . "/vimtmp")
    call mkdir($HOME . "/vimtmp")
endif

if isdirectory($HOME . "/vimtmp")
    set directory=$HOME/vimtmp//,$HOME/tmp//,$TEMP//
else
    set directory=$HOME/tmp//,$TEMP//,.
endif

"Line numbers
set nu

"Always show status line
set laststatus=2

"Filename as you typed, whether modified, readonly, filetype, line,column, percentage, total no. of lines
set statusline=%n\ %f\ %m%y\ %l,%c\ %p%%(Total:%L)\ \ \ %r

"Change tabs to spaces
set expandtab
"Change a tab to 4 spaces
set tabstop=4
"Indent to 4 spaces (in autoindent, etc.)
set shiftwidth=4

"Remove search as you type as it's too slow in remote systems
set noincsearch

"Enable backspace
set bs=2

"Store many commands - default is 20
set history=100

"Automatically chdir to the directory of the current file
set autochdir

" Show matching brackets
set showmatch

" paste mode - this will avoid unexpected effects (unnecessary indentation) when you
" cut or copy some text from one window and paste it in Vim. 
set pastetoggle=<F11>

" For perl6 syntax highlighting 
autocmd BufNewFile,BufRead *.pl6 set filetype=perl6
autocmd FileType perl6 set syntax=perl6

" When tab completion has multiple completions, complete upto longest common prefix and show options
set wildmode=list:longest

" Modelines (vim: ex: etc) have security concerns, disable them by default
set nomodeline

" Set foreground and background colors of folded lines to be less irritating
highlight Folded ctermfg=DarkMagenta
highlight Folded ctermbg=White
if has('gui_running')
    highlight Folded guifg=DarkMagenta
    highlight Folded guibg=White
    set guifont=Consolas:h13:cANSI
endif

" Ignore case generally, but do it case sensitively if I type capital letters
set ignorecase smartcase

" A color scheme that suits me - dark backgrounded with ordinary text green
colorscheme murphy

autocmd BufNewFile,BufRead *.json set ft=json

augroup json_autocmd
    autocmd!
    autocmd FileType json set autoindent
    autocmd FileType json set formatoptions=tcq2l
    autocmd FileType json set textwidth=78
augroup END

"When I switch buffers just hide the old buffer, don't lose its undo history
set hidden 

"When switching buffers, preserve window view.
if v:version >= 700
  au BufLeave * if !&diff | let b:winview = winsaveview() | endif
  au BufEnter * if exists('b:winview') && !&diff | call winrestview(b:winview) | endif
endif

