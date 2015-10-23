" Vim

"""" Compatibility options
" Don't act like old guy vi, give me the features of vim
set nocp
" When moving the cursor up or down just after inserting indent for 'autoindent',
" do not delete the indent.
set cpoptions+=I
" Allow editing command pasted from clipboard using :@r (where r is register)
set cpoptions-=e
" When using "w!" while the 'readonly' option is set, don't reset 'readonly'.
" set cpoptions+=Z

"""" Debugging Vim
" Toggle verbosity - useful when debugging issues
function! ToggleVerbose()
    if !&verbose
        set verbosefile=~/vimlog/verbose.log
        set verbose=15
    else
        set verbose=0
        set verbosefile=
    endif
endfunction

"""" Fundamental Pre-Plugin options
" UTF-8 FTW!
set encoding      =utf-8
set fileencoding  =utf-8
set fileencodings =ucs-bom,utf8

" Enable omnicomplete
set omnifunc=syntaxcomplete#Complete

" Space is the <leader> key
let mapleader=" "

" Clear old autocmd's (when this is loading by :so for eg.)
" Do them all together at the top so you don't need to worry about reordering
" augroups that are split in multiple places
autocmd!
augroup general_vim_au
    autocmd!
augroup END
augroup filetype_au
    autocmd!
augroup END
"""" Vundle package management
" Add .vim to rtp even on Windows, to get non-Vundle changes picked up
set rtp+=~/.vim/

let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if filereadable(vundle_readme)
    let iCanHazVundle=1

    filetype off                   " required!
    set rtp+=~/.vim/bundle/Vundle.vim/
    call vundle#begin()

    " let Vundle manage Vundle
    " required!
    Plugin 'VundleVim/Vundle.vim'

    ""  General editing plugins
    Plugin 'tpope/vim-surround.git'
    Plugin 'tpope/vim-repeat.git'
    Plugin 'tpope/vim-unimpaired.git'
    Plugin 'tpope/vim-characterize.git'
    Plugin 'tpope/vim-abolish'
    Plugin 'tpope/vim-scriptease'
    Plugin 'godlygeek/tabular'
    Plugin 'ctrlpvim/ctrlp.vim'
    Plugin 'fisadev/vim-ctrlp-cmdpalette'
    Plugin 'sjl/gundo.vim'
    Plugin 'compview'
    Plugin 'othree/eregex.vim'
    Plugin 'bling/vim-airline'
    Plugin 'vim-scripts/utl.vim'
    Plugin 'mjbrownie/swapit'
    Plugin 'vim-scripts/EasyGrep'
    Plugin 'mileszs/ack.vim'
    Plugin 'ntpeters/vim-better-whitespace'
    Plugin 'terryma/vim-multiple-cursors'
    Plugin 'tpope/vim-fugitive'

    "" Colorschemes
    Plugin 'digital-carver/vim-colors-sunburst'   "dark
    Plugin 'digital-carver/sprinkles'     "both light and dark
    Plugin 'acarapetis/vim-colors-github' "light

    "" Programming specific plugins
    Plugin 'AndrewRadev/splitjoin.vim'
    Plugin 'vim-scripts/matchit.zip'
    Plugin 'scrooloose/nerdcommenter'
    Plugin 'scrooloose/syntastic'

    " (SnipMate and dependencies)
    Plugin 'MarcWeber/vim-addon-mw-utils'
    Plugin 'tomtom/tlib_vim'
    Plugin 'garbas/vim-snipmate'
    Plugin 'honza/vim-snippets'
    set rtp+=~/.vim/my-snipmate-snippets/

    Plugin 'mattn/emmet-vim'
    Plugin 'othree/html5.vim'
    Plugin 'jcf/vim-latex'
    Plugin 'wannesm/wmgraphviz.vim'
    Plugin 'elzr/vim-json'
    Plugin 'wting/rust.vim'
    Plugin 'PProvost/vim-ps1'
    Plugin 'avakhov/vim-yaml'
    Plugin 'vim-ruby/vim-ruby'
    Plugin 'tpope/vim-markdown'
    if has('unix')
        "perlomni doesn't work perfectly on Windows, needs piping and some Unix
        "commands
        Plugin 'c9s/perlomni.vim'
        "hdevtools on Windows requires unix haskell package which requires
        "mingw, ultimately a hassle to maintain
        Plugin 'bitc/vim-hdevtools'
    endif

    call vundle#end()
endif
" Indent automatically according to filetype
filetype plugin indent on

"""" General (non-plugin-specific, non-filetype-specific) Vim settings
" Syntax highlighting
syntax on

" Line at 80th column just for a reference
set colorcolumn=80
augroup general_vim_au
    " Do it after the ColorScheme is set, so we can override its setting
    autocmd ColorScheme * if &background == "dark" |
                \ highlight ColorColumn guibg=#101010 ctermbg=DarkGray |
                \ else |
                \ highlight ColorColumn guibg=#FCEFCF ctermbg=LightGray
augroup END

" Set colorscheme according to environment
if empty($VIMCOLORSCHEME)
    if has('gui_running')
        set background=light
        " a bright colorscheme to go with the usually bright-looking GUIs
        try
            colorscheme sprinkles
        catch /E185/ " colorscheme does not exist
            colorscheme delek
        endtry
    else
        set background=dark
        " a dark colorscheme in the usually-dark terminals
        try
            colorscheme sunburst
        catch /E185/ " colorscheme does not exist
            colorscheme murphy
            "ron is good too
        endtry
    endif
else
    colorscheme $VIMCOLORSCHEME
endif

" Backups are not in your job description, thankyouverymuch
set nobackup
set nowritebackup

" Highlight some special lines
let matchIDSpecialComment = matchadd('SpecialComment', '^\s*#\s*HACK.*')

" search for tags in current dir, then upwards
set tags=./tags;/,tags;/

set autoindent
" Always use just \n as newline, not \r\n
autocmd BufEnter set fileformat=unix

" Do not store global and local option values in a session, since refreshing
" them via .vimrc is often the whole point
set ssop-=options

" Line numbers
set nu
set relativenumber

" Keep a few extra lines visible when scrolling
set scrolloff=3

" Always show status line
set laststatus=2

" Filename as you typed, whether modified, readonly, filetype, line,column,
" percentage, total no. of lines
set statusline=%n\ %f\ %m%y\ %l,%c\ %p%%(Total:%L)\ \ \ %r

" Change tabs to spaces
set expandtab
" Change a tab to 4 spaces
set tabstop=4
" Indent to 4 spaces (in autoindent, etc.)
set shiftwidth=4

" Don't auto-commentify the next line after a comment
set formatoptions-=ro
if v:version >= 740
    "When joining lines, try to join comments intelligently (only in v7.4+)
    set formatoptions+=j
endif

" Remove search-as-you-type as it's too slow in remote systems
set noincsearch

" Substitutions happen over whole line by default, add /g to do only one sub
set gdefault

" Enable backspace
set bs=2

" Store many commands - default is 20
set history=100

" Show matching brackets
set showmatch

" Highlight search results (use <leader>l to clear these, ref: #tn=nohlsearch )
set hlsearch

" paste mode - this will avoid unexpected effects (unnecessary indentation) when
" you cut or copy some text from one window and paste it in Vim.
set pastetoggle=<F11>

" Avoid creating temporary files in source directories
if ! isdirectory($HOME . "/vimtmp")
    call mkdir($HOME . "/vimtmp")
endif

if isdirectory($HOME . "/vimtmp")
    set directory=$HOME/vimtmp//,$HOME/tmp//,$TEMP//
    set undodir=$HOME/vimtmp/,$HOME/tmp/,$TEMP/
else
    set directory=$HOME/tmp//,$TEMP//,.
    set undodir=$HOME/tmp/,$TEMP/
endif

augroup general_vim_au
    " Enable undo-ing of :bdelete
    autocmd BufDelete * let g:latest_deleted_buffer = expand("<afile>:p:gs?\\?/?")
    nnoremap <C-S-t> :e <C-R>=g:latest_deleted_buffer<CR><CR>

    " Remove stupid comment-related formatoptions set by ftplugins
    autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
augroup END

" When tab completion has multiple completions, complete upto
" longest common prefix and show options
set wildmode=list:longest

" Set foreground and background colors of folded lines to be more pleasant
highlight Folded ctermfg=DarkMagenta
highlight Folded ctermbg=White

" Open help in new tab
cnoreabbrev <expr> h getcmdtype() == ":" && getcmdline() == 'h' ?
            \ 'tab help' :
            \ 'h'
function! GetHelpOnCwordInTab()
    if &filetype == "vim"
        execute 'tab help ' . expand("<cword>")
    else
        execute 'tabnew <bar> read ! ' . &keywordprg . expand("<cword>")
    endif
endfunction
autocmd general_vim_au FileType * nnoremap <C-K> :call GetHelpOnCwordInTab()<CR>

" Ignore case generally, but do it case sensitively if I type capital letters
set ignorecase smartcase wildignorecase

" When I switch buffers just hide the old buffer, don't lose its undo history
set hidden

" When switching buffers, preserve window view.
if v:version >= 700
    au BufLeave * if !&diff | let b:winview = winsaveview() | endif
    au BufEnter * if exists('b:winview') && !&diff |
                \ call winrestview(b:winview) | endif
endif

" Disable the 'ding' error bell sound
set vb t_vb=

" Use filler empty lines when one side of diff has content and other doesn't
" Show 3 lines of context around differences (default: 6)
" Open diff's in vertical splits rather than the default horizontal
set diffopt=filler,context:3,vertical

" Options for netrw file browser
let g:netrw_banner         = 0
let g:netrw_keepdir        = 0
let g:netrw_liststyle      = 3
let g:netrw_sort_options   = 'i'
let g:netrw_fastbrowse     = 2
let g:netrw_special_syntax = 1

""" GUI Options
if has('gui_running')
    highlight Folded guifg=DarkMagenta
    highlight Folded guibg=White
    set guioptions-=g
    set guioptions-=m
    set guioptions-=t
    set guioptions-=T
    "" Cursor Options
    " Common options for all cursor modes
    set guicursor=a:Cursor/lCursor-blinkwait1500-blinkon400-blinkoff400
    " Cursor during normal-visual-commandlinenormal modes
    set guicursor=n-v-c:hor10
    " Cursor during insert mode
    set guicursor+=i:ver10
    " Cursor during commandlineinsert mode
    set guicursor+=ci:ver20
    " Cursor during replace-commandlinereplace modes
    set guicursor+=r-cr:block
    " Cursor during waitingforoperation mode
    set guicursor+=o:hor50
    " Cursor during showmatch mode within insert mode
    set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175",
    if has('gui_win32')
        set guifont=Source\ Code\ Pro:h13:cDEFAULT,Consolas:h13:cDEFAULT
        set shellslash
        au FileType vundle setlocal noshellslash
    elseif has('gui_gtk2')
        set guifont=Dejavu\ Sans\ Mono\ 12
    endif
endif

"""" Basic Vim Mappings

" F6 switches windows
map <F6> <C-W>p
" Make F6 work in insert mode too
imap <F6> <ESC><F6>

" Ctrl Tab and Ctrl Shift Tab for buffer switching
map <C-Tab> :bn<CR>
map <C-S-Tab> :bp<CR>

" And Space+d to delete this buffer quickly
nmap <leader>d :bd<CR>

" - saves
map - :up<CR>
" Make F2 save insert mode, and take me back to insert mode
imap <F2> <ESC>-a

" Fold and unfold with shift-<Space>
nmap <S-Space> za

" Switch 0 and ^ since we most often want to go to start of text rather than
" line itself, and 0 is much easier to type
nnoremap 0 ^
nnoremap ^ 0

" Clear search highlighting by pressing leader-L (similar to Ctrl-L for
" clearing in console)
nnoremap <leader>l :nohlsearch<CR>

" Turn ; into the ex mode initiator
nnoremap ; :
vnoremap ; :
" Usually ; finds next f match, now let , do that
nnoremap , ;
vnoremap , ;
" And let the unused backspace key do the reverse f match work of ,
nnoremap <bs> ,
vnoremap <bs> ,

" Work with system clipboard simply with leader
vmap <leader>y "+y
vmap <leader>d "+d
vmap <leader>p "+p
vmap <leader>P "+P
nmap <leader>p "+p
nmap <leader>P "+P

" F12 in insert mode to insert current date and time
" wanted C-; mapping (like in Evernote), but that doesn't work
" (probably some plugin conflict or something)
inoremap <F12> <C-R>=strftime("%c")<CR>

" Open netrw explorer in vertical split similar to NERDTree
map <F10> :Lexplore<CR>

" Mapping to switch to current file's directory
" (autochdir is erratic and some plugins don't like it)
nnoremap <leader>/ :lcd %:p:h<CR>
vnoremap <leader>/ :lcd %:p:h<CR>

inoremap jk <ESC>

nnoremap <leader>rtp :below new \| execute append(0, &runtimepath) \| s/,/\r/ \| setlocal buftype=nofile<CR>

"""" Filetype Specific Settings
augroup filetype_au
    " Show pydoc help for current word when shift-K is pressed
    autocmd FileType python setlocal keywordprg=pydoc
    let python_highlight_all = 1

    autocmd FileType perl setlocal keywordprg=perldoc\ -f
    let perl_include_pod   = 1    "include pod.vim syntax file with perl.vim
    let perl_extended_vars = 1    "highlight complex expressions such as @{[$x, $y]}
    let perl_sync_dist     = 250  "use more context for highlighting

    autocmd FileType ruby setlocal keywordprg=ri\ -T

    " For perl6 syntax highlighting
    autocmd BufNewFile,BufRead *.pl6 set filetype=perl6
    autocmd FileType perl6 set syntax=perl6

    " Now for JSON
    autocmd BufNewFile,BufRead *.json set ft=json
    autocmd FileType json set autoindent
    autocmd FileType json set formatoptions=tcq2l

    " And for Markdown
    autocmd BufNewFile,BufRead *.md set ft=markdown
    autocmd FileType markdown setlocal tabstop=2 shiftwidth=2
    " Indented code blocks mess with subsublists, so I'll use fenced ``` code
    " blocks and disable these
    autocmd Syntax markdown syn clear markdownCodeBlock
    " And also allow lists to be detected with any number of spaces at beginning,
    " not just {0, 4} (the change from markdown.vim is just that: (\t\| \|\)
    autocmd Syntax markdown syn match markdownListMarker
                \ "\%(\t\| \+\)[-*+]\%(\s\+\S\)\@=" contained
    autocmd Syntax markdown syn match markdownOrderedListMarker
                \ "\%(\t\| \+\)\<\d\+\.\%(\s\+\S\)\@=" contained

    " When there is a .sh file, assume it's bash
    "let g:is_bash = 1

    " A mapping for HTML files - to reindent using tidy (commented bcos tidy is an
    " idiot, tidy-html5 is yet to be installed)
    " autocmd FileType html nmap <leader>= :!tidy -m -config $HOME/tidy_wsonly.cfg %
    " And set set indentation to two spaces, since HTML has lots of nesting
    autocmd FileType html setlocal tabstop=2 shiftwidth=2

    " Treat .tex files as latex by default instead of 'plaintex'
    let g:tex_flavor='latex'
    let g:Tex_UsePython=0

    " Enable spell-checking only for plaintext files, and no 80-col marker
    autocmd FileType text setlocal spell spelllang=en_gb | set colorcolumn=
    " Help files somehow get the above spell applied on them, so explicitly
    " disable that
    autocmd FileType help setlocal nospell

augroup END

"""" Plugin-Specific Options
""" Plugin Option Variable
" These ones needs to happen in .vimrc directly, as they might affect the
" forthcoming scripts' functioning. And it's just variable assignments, so
" no error even if no plugin

"" emmet Options
let g:user_emmet_leader_key = '<C-j>'
let g:user_emmet_settings = {
            \    'html' : {
            \        'indentation' : '  '
            \    },
            \}

"" CtrlP Options
let g:ctrlp_working_path_mode   = 'c'
let g:ctrlp_show_hidden         = 1
let g:ctrlp_mruf_max            = 100
let g:ctrlp_extensions          = ['tag', 'rtscript', 'changes',
            \ 'mixed', 'bookmarkdir']
let g:ctrlp_match_window        = 'order:ttb,min:1,max:10,results:100'
let g:ctrlp_use_caching         = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_max_files           = 1024
let g:ctrlp_custom_ignore       = {
            \ 'dir':  '\v[\/]\.(git|hg|svn)$',
            \ 'file': '\v\.(exe|so|dll)$',
            \ }
if has("win32")
    let g:ctrlp_mruf_case_sensitive = 0
endif

"" Syntastic Options
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_enable_balloons          = 1
let g:syntastic_loc_list_height          = 6
let g:syntastic_mode_map                 = {
            \ "mode": "passive",
            \ "active_filetypes": ["", ""],
            \ "passive_filetypes": ["html"] }

"" Airline Options
let g:airline#extensions#tabline#enabled        = 1
let g:airline#extensions#tabline#show_buffers   = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#tabline#show_tabs      = 0
let g:airline#extensions#csv#column_display     = 'Name'

"" Better Whitespace Options
let g:better_whitespace_enabled = 0

"" SnipMate Options
imap <C-Space> <Plug>snipMateNextOrTrigger
smap <C-Space> <Plug>snipMateNextOrTrigger
xmap <C-Space> <Plug>snipMateVisual

imap <C-m>b <Plug>snipMateBack
smap <C-m>b <Plug>snipMateBack

imap <C-m>s <Plug>snipMateShow

let g:snipMate = {}
let g:snipMate.snippet_version = 1

""" After-Plugin Settings
" These are "supposed to be" set in after/plugin directory, but then
" cross-platform synchronization would get even messier. So, au VimEnter it is.

function! SetPluginConfigNow()

    " vim-hdevtools Config
    " This plugin's stuff all gets loaded only dynamically as needed, so
    " directly check file existence
    if !empty(glob('$HOME/.vim/bundle/vim-hdevtools/autoload/hdevtools.vim'))
        au FileType haskell nnoremap <buffer> <leader>t :HdevtoolsType<CR>
        au FileType haskell nnoremap <buffer> <leader>c :HdevtoolsClear<CR>
    endif

    " CtrlP Config
    if exists(":CtrlP")
        " to be able to call CtrlP with default search text
        function! CtrlPWithText(search_text, ctrlp_command_end)
            execute ':CtrlP' . a:ctrlp_command_end
            call feedkeys(a:search_text)
        endfunction

        "let g:ctrlp_map = '<Space>f' "doesn't really work, so...
        nmap <leader>f   :CtrlP<CR>
        nmap <leader>or  :CtrlPRoot<CR>
        nmap <leader>b   :CtrlPBuffer<CR>
        nmap <leader>ot  :CtrlPTag<CR>
        nmap <leader>oV  :CtrlPRTS<CR>
        nmap <leader>oc  :CtrlPChange<CR>
        nmap <leader>om  :CtrlPMRU<CR>
        nmap <leader>oa  :CtrlPMixed<CR>
        nmap <leader>ob  :CtrlPBookmarkDir<CR>

        " CtrlP with default text
        nmap <leader>owt  :call CtrlPWithText(expand('<cword>'), 'Tag')<CR>
        nmap <leader>owf  :call CtrlPWithText(expand('<cword>'), '')<CR>
        nmap <leader>of   :call CtrlPWithText(expand('<cfile>'), '')<CR>
    endif

    " CtrlP-CmdPalette Config
    if exists(":CtrlPCmdPalette")
        nmap <leader>ov :CtrlPCmdPalette<CR>
    endif

    " Tabular Config
    if exists(":Tabularize")
        nmap <leader>a= :Tabularize /=<CR>
        vmap <leader>a= :Tabularize /=<CR>
        nmap <leader>a: :Tabularize /:\zs<CR>
        vmap <leader>a: :Tabularize /:\zs<CR>
    endif

    " Syntastic Config
    if exists(":SyntasticCheck")
        let g:syntastic_stl_format = '[Syntax: line:%F (%e+%w)]'
        set statusline+=%#warningmsg#
        set statusline+=%{SyntasticStatuslineFlag()}
        set statusline+=%*

        " On windows, git bash gives better return values to Syntastic, but
        " interferes with fugitive, so set it only as syntastic_shell and not
        " general vim shell
        if has("win32")
            let g:syntastic_shell = "$GIT_BIN/bash.exe"
        endif

        nmap <leader>sc :SyntasticCheck<CR>
        nmap <leader>sC :SyntasticReset<CR>
        " This one without a <CR> at the end, so that you can
        " specify a checker if you want
        nmap _ :up | SyntasticCheck
    endif

    " Airline Config
    if exists(":AirlineToggle")
    endif

    " Utl Config
    if exists(":Utl")
        nnoremap <leader>ul :Utl openLink underCursor<CR>
        nnoremap <leader>uc :Utl copyLink underCursor<CR>
    endif

    " Abolish Config
    if exists(":Abolish")
        Abolish teh the
        Abolish soem{thing,one} some{}
    endif

    " Allow PCRE in Tabularize if eregex E2v() is available
    if exists(':Tabularize') && exists(':E2v')
        function! AlignByRE() range
            let range  = a:firstline . ',' . a:lastline
            let cmd    = range
            let re = input('Enter PCRE to align by: ')
            if re == ""
                " Run empty to use previous pattern
                let cmd .= 'Tabularize'
                execute cmd
            else
                let vim_re  = E2v(re)
                let cmd    .= 'Tabularize/' . vim_re
            endif
            execute cmd
        endfunction
        nnoremap <leader>A :call AlignByRE()<CR>
        vnoremap <leader>A :call AlignByRE()<CR>
    endif

    " Better Whitespace Config
    if exists(":StripWhitespace")
        nmap <Space><Space> :ToggleWhitespace<CR>
        nmap <Space><S-Space> :StripWhitespace<CR>
    endif
endfunction

augroup vimenter_au
    au VimEnter * call SetPluginConfigNow()
augroup END

"""" Final Vim-Startup Commands
" Start out in my repositories directory
if ! empty($REPOS)
    cd $REPOS
endif

"""" Modelines
""" Folding - four " for top-level fold, three for sub-fold, two sub-sub-fold
" vim:fdm=expr:fdl=0
" vim:fde=getline(v\:lnum)=~'^""'?'>'.(5-matchend(getline(v\:lnum),'""*'))\:'='

