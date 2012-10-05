" This must be first, because it changes other options as side effect
set nocompatible

" Use pathogen to easily modify the runtime path to include all
" plugins under the ~/.vim/bundle directory
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" Quickly edit/reload the vimrc file
nmap <silent> <leader>ev :e $MYVIMRC<CR>
nmap <silent> <leader>sv :so $MYVIMRC<CR>

set hidden

set expandtab
set nowrap        " don't wrap lines
set tabstop=4     " a tab is four spaces
set backspace=indent,eol,start
                  " allow backspacing over everything in insert mode
set autoindent    " always set autoindenting on
set copyindent    " copy the previous indentation on autoindenting
set smartindent
set number        " always show line numbers
set shiftwidth=4  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
                  "    case-sensitive otherwise
set smarttab      " insert tabs on the start of a line according to
                  "    shiftwidth, not tabstop
set hlsearch      " highlight search terms
set incsearch     " show search matches as you type

set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set novisualbell           " don't beep
set noerrorbells         " don't beep

set nobackup
set noswapfile

:filetype plugin on
set ofu=syntaxcomplete#Complete

if has('autocmd')
    autocmd filetype php set expandtab
endif

set t_Co=256

if &t_Co >= 256 || has("gui_running")
   colorscheme zenburn
   " colorscheme pyte
endif

if &t_Co > 2 || has("gui_running")
   " switch syntax highlighting on, when the terminal has colors
   syntax on
endif

set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.
autocmd filetype html,xml set listchars-=tab:>.

set pastetoggle=<F2>
nnoremap ; :

" Use Q for formatting the current paragraph (or selection)
vmap Q gq
nmap Q gqap

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

nnoremap j gj
nnoremap k gk

" Easy window navigation
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nmap <silent> ,/ :nohlsearch<CR>

cmap w!! w !sudo tee % >/dev/null

:nnoremap <C-n> :bnext<CR>
:nnoremap <C-p> :bprevious<CR>
:nnoremap <Tab> :bnext<CR>
:nnoremap <S-Tab> :bprevious<CR>

" NERDTree settings {{{
" Put focus to the NERD Tree with F3 (tricked by quickly closing it and
" immediately showing it again, since there is no :NERDTreeFocus command)
nmap <leader>n :NERDTreeClose<CR>:NERDTreeToggle<CR>
nmap <leader>m :NERDTreeClose<CR>:NERDTreeFind<CR>
nmap <leader>N :NERDTreeClose<CR>

" Store the bookmarks file
let NERDTreeBookmarksFile=expand("$HOME/.vim/NERDTreeBookmarks")

" Show the bookmarks table on startup
let NERDTreeShowBookmarks=1

" Show hidden files, too
let NERDTreeShowFiles=1
let NERDTreeShowHidden=1

" Quit on opening files from the tree
"let NERDTreeQuitOnOpen=1

" Highlight the selected entry in the tree
let NERDTreeHighlightCursorline=1

" Use a single click to fold/unfold directories and a double click to open
" files
let NERDTreeMouseMode=2

" Don't display these kinds of files
let NERDTreeIgnore=[ '\.pyc$', '\.pyo$', '\.py\$class$', '\.obj$',
            \ '\.o$', '\.so$', '\.egg$', '^\.git$', '^\.svn$' ]

" }}}

" CTAGS
set tags=tags,~/.vim/tags/paypoint

map <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
map <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR>

function! UPDATE_TAGS()
  let _f_ = expand("%:p")
  let _cmd_ = 'ctags --languages=php -a -f ~/.vim/tags/gradwell '. _f_
  let _resp = system(_cmd_)
  unlet _cmd_
  unlet _f_
  unlet _resp
endfunction
autocmd BufWrite *.php silent! call !UPDATE_TAGS()

" NerdTREE
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

" PHP helpers
function PhpLintCheck()
    let lcheck=system("/usr/bin/env php -l ".expand("%"))
    call LibNotify("Lint Check", lcheck)
    "echo lcheck
endfunction

function LibNotify(sub, msg)
    "echo a:sub ": " a:msg
    let _cmd_ = "/usr/bin/notify-send -t 5000 -u low -i '". a:sub. "' '". a:msg. "'"
    " echo _cmd_
    let _notify_ = system(_cmd_)
    unlet _cmd_
    unlet _notify_
endfunction

":autocmd FileType php noremap <C-l> :!/usr/bin/env pgnome2hp -l %<CR>
:autocmd FileType php noremap <C-l> :!/usr/bin/env php -l % \|\| tail /var/log/php/error_log<CR>
:autocmd BufWritePost *.php :call PhpLintCheck()

" set background=dark
"hi TooLong guibg=#ff0000 guifg=#f8f8f8

" Good readable space-saving font for lcd/lvds that doesn't need antialising
" but just makes good use of the pixels
set guifont=Terminus\ Bold\ 8
"
" This is a ttf/antialised font thats nice for coding, too.
"set guifont=ProggyClean\ TT\ 11.7
"
set linespace=0 " Pixels of space between lines

" Fuzzy matching
:nnoremap <C-f> :FufFile<CR>
:nnoremap <C-b> :FufBuffer<CR>

" TaskList plugin
let g:tlTokenList = ['TODO', 'FIXME', '@todo', 'XXX']
let g:tlRememberPosition = 1
let Tlist_Show_One_File = 1
let Tlist_Process_File_Always = 1
let Tlist_Show_Menu = 1
let Tlist_Use_Right_Window = 1
let Tlist_GainFocus_On_ToggleOpen = 1
let Tlist_Auto_Open = 1

nmap <leader>T :TlistToggle<CR>

if has("autocmd") && exists("+omnifunc")
    autocmd Filetype *
    \   if &omnifunc == "" |
    \     setlocal omnifunc=syntaxcomplete#Complete |
    \   endif
endif

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" Tell vim to remember certain things when we exit
" "  '10  :  marks will be remembered for up to 10 previously edited files
" "  "100 :  will save up to 100 lines for each register
" "  :20  :  up to 20 lines of command-line history will be remembered
" "  %    :  saves and restores the buffer list
" "  n... :  where to save the viminfo files
set viminfo='10,\"100,:20,%,n~/.viminfo

set mouse=a

" create a quicker mapping to get out of insert mode
:inoremap jk <esc>
" as we are sadistic remove the normal escape for insert mapping :-)
:inoremap <esc> <nop>

:iabbrev ssig --<cr>William Elworthy<cr>will@mettaengine.co.uk
