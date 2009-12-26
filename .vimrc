"

"Don't act like old guy vi, give me the features of vim
set nocp

if !has("gui_running")
    "For colors
    set term=xtermc
endif

"Syntax highlighting
syntax on

"Indent automatically according to filetype
filetype indent on

""" MAPPINGS
"" Normal Mode Mappings
"F6 switches windows
map <F6> <C-W>p
"F5 runs code and shows output in the other window
map <F5> -:let code = "r!perl " . bufname("%")<CR> <F6>gg0<ESC>:exe code<CR>

"- saves
map - :up<CR>

"Switch 0 and ^ since we most often want to go to start of text rather than 
"line itself, and 0 is much easier to type
nnoremap 0 ^
nnoremap ^ 0

"" Insert Mode Mappings
"Make F2 save insert mode, and take me back to insert mode
imap <F2> <ESC>-a

"Make F5 and F6 work in insert mode too
imap <F6> <ESC><F6>
imap <F5> <ESC><F5>

"Control-<navigation character> to move in insert mode
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

" Avoid creating temporary files in source directories
if ! isdirectory(expand('~/vimtmp'))
    call mkdir(expand('~/vimtmp'))
endif
if isdirectory(expand('~/vimtmp'))
    set directory=~/vimtmp,~/tmp
else
    set directory=~/tmp,/var/tmp,/tmp,.
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

" Make sure vim searches all the upper directories for the tags file.
" See: http://www.vim.org/tips/tip.php?tip_id=94
" [Project-specific settings removed for privacy (and confidentiality?)]

"Enables many plugins
filetype plugin on

" Show matching brackets
set showmatch

" paste mode - this will avoid unexpected effects (unnecessary indentation) when you
" cut or copy some text from one window and paste it in Vim. 
set pastetoggle=<F11>

" Use space for opening and closing folds
nnoremap <space> za
vnoremap <space> zf

" When tab completion has multiple completions, complete upto longest common prefix and show options
set wildmode=list:longest

" Show help for current word when F4 is pressed
autocmd FileType python map <F4> :execute 'let cw=expand("<cword>")' \| vnew \| execute "r!pydoc " cw<CR>
autocmd FileType python imap <F4> <ESC><F4>
let python_highlight_all = 1

autocmd FileType perl map <F4> :execute 'let cw=expand("<cword>")' \| vnew \| execute "r!perldoc -f" cw<CR>
autocmd FileType perl imap <F4> <ESC><F4>
autocmd FileType perl map <C-F4> :execute 'let cw=expand("<cword>")' \| vnew \| execute "r!perldoc -q" cw<CR>
autocmd FileType perl imap <C-F4> <ESC><C-F4>

" Set foreground and background colors of folded lines to be less irritating
highlight Folded ctermfg=DarkMagenta
highlight Folded ctermbg=White
if has('gui_running')
    highlight Folded guifg=DarkMagenta
    highlight Folded guibg=White
endif

"set guifont=LucidaSansTypLat5\ 12
set guifont=Bitstream\ Vera\ Sans\ Mono\ 13

" Ignore case generally, but do it case sensitively if I type capital letters
set ignorecase smartcase

colorscheme murphy

