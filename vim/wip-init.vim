" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

" install minpac
" git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac

if exists('*minpac#init')
  " minpac is loaded
  call minpac#init()

  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " advanced syntax vim script
  call minpac#add('vim-jp/syntax-vim-ex')
  " comment stuff out
  call minpac#add('tpope/vim-commentary')
  " git wrapper
  call minpac#add('tpope/vim-fugitive')
  " git diff
  call minpac#add('jreybert/vimagit')
  " status tabline
  call minpac#add('vim-airline/vim-airline')
  " status tabline themes
  call minpac#add('vim-airline/vim-airline-themes')
  " git diff in gutter
  call minpac#add('airblade/vim-gitgutter')
  " grep search tools
  call minpac#add('vim-scripts/grep.vim')
  " gvim-only colorschemes work in terminal vim
  call minpac#add('vim-scripts/CSApprox')
  " trailing whitespace
  call minpac#add('bronson/vim-trailing-whitespace')
  " insert mode auto-completion for quotes, parens, brackets, etc.
  call minpac#add('Raimondi/delimitMate') " mmm
  " tagbar
  call minpac#add('majutsushi/tagbar')
  " display the indention levels with thin vertical lines
  call minpac#add('Yggdroot/indentLine')
  " language pack
  call minpac#add('sheerun/vim-polyglot')
  " fuzzy finder
  call minpac#add('junegunn/fzf', {'dir': '~/.fzf', 'do': '!./install --all'})
  call minpac#add('junegunn/fzf.vim')

  let g:make = 'gmake'
  if exists('make')
    let g:make = 'make'
  endif
  call minpac#add('Shougo/vimproc.vim', {'do': g:make})

  " async lint engine
  call minpac#add('w0rp/ale')

  "" Snippets
  "Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'

  call minpac#add('tomasr/molokai')
  call minpac#add('altercation/vim-colors-solarized')

  " elixir
  call minpac#add('elixir-lang/vim-elixir')
  call minpac#add('carlosgaldino/elixir-snippets')

  " elm
  "" Elm Bundle
  call minpac#add('elmcast/elm-vim')

  " html
  "" HTML Bundle
  call minpac#add('hail2u/vim-css3-syntax')
  call minpac#add('gorodinskiy/vim-coloresque')
  call minpac#add('tpope/vim-haml')
  call minpac#add('mattn/emmet-vim')

  " javascript
  "" Javascript Bundle
  call minpac#add('jelera/vim-javascript-syntax')

  " php
  "" PHP Bundle
  call minpac#add('arnaud-lb/vim-php-namespace')

  " python
  "" Python Bundle
  call minpac#add('davidhalter/jedi-vim')
  call minpac#add('raimon49/requirements.txt.vim', {'for': 'requirements'})

  " manages tag files
  call minpac#add('ludovicchabant/vim-gutentags')

  " dark powered neo-completion
  call minpac#add('Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' })

  " markdown
  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('jtratner/vim-flavored-markdown')

  " elixir
  call minpac#add('slashmili/alchemist.vim')
  call minpac#add('c-brenn/phoenix.vim')

  " php
  call minpac#add('stanangeloff/php.vim')
  call minpac#add('lvht/phpcd.vim')
  "" symfony
  call minpac#add('docteurklein/vim-symfony')
  " PHP autocomplete
  call minpac#add('shawncplus/phpcomplete.vim')
  " PHPcomplete
  "call minpac#add('m2mdas/phpcomplete-extended')
  " PHPcomplete symfony
  "call minpac#add('m2mdas/phpcomplete-extended-symfony')
  " PHP namespace
  call minpac#add('arnaud-lb/vim-php-namespace')
  " PHP documentator
  call minpac#add('tobys/pdv')
  " PHP vim syntax
  call minpac#add('StanAngeloff/php.vim')
  " twig
  call minpac#add('evidens/vim-twig')

  " Mustache template system (per pdv)
  call minpac#add('tobys/vmustache')

  " docker
  call minpac#add('infoslack/vim-docker')

  " dark powered plugin for Neovim/Vim to unite all interfaces
  call minpac#add('shougo/denite.nvim')

  " github for fugitive
  call minpac#add('tpope/vim-rhubarb')

  " Vim sugar for the UNIX shell commands that need it the most
  call minpac#add('tpope/vim-eunuch')

  " bookmarks
  call minpac#add('MattesGroeger/vim-bookmarks')

  " distraction free writing
  call minpac#add('junegunn/goyo.vim')

  " hyperfocus-writing
  call minpac#add('junegunn/limelight.vim')

  " physics-based smooth scrolling
  call minpac#add('yuttie/comfortable-motion.vim')

  " unload, delete or wipe a buffer without closing the window or split
  call minpac#add('qpkorr/vim-bufkill')

  " nerdtree
  call minpac#add('scrooloose/nerdtree')
  call minpac#add('jistr/vim-nerdtree-tabs')

  " icons for NERDTree
  call minpac#add('ryanoasis/vim-devicons')

  " session
  call minpac#add('tpope/vim-obsession')
endif


" Required:
filetype plugin indent on


"*****************************************************************************
"" Basic Setup
"*****************************************************************************"
"" Encoding
set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8
set bomb
set binary


"" Fix backspace indent
set backspace=indent,eol,start

"" Tabs. May be overriten by autocmd rules
set tabstop=4
set softtabstop=0
set shiftwidth=4
set expandtab

"" Map leader to ,
let mapleader=','

"" Enable hidden buffers
set hidden

"" Searching
set hlsearch
set incsearch
set ignorecase
set smartcase

"" Directories for swp files
set nobackup
set noswapfile

set fileformats=unix,dos,mac

if exists('$SHELL')
  set shell=$SHELL
else
  set shell=/bin/sh
endif

"*****************************************************************************
"" Visual Settings
"*****************************************************************************
syntax on
set ruler
set number
set colorcolumn=120

let no_buffers_menu=1

colorscheme molokai

set mousemodel=popup
set t_Co=256
set guioptions=egmrti
set gfn=Monospace\ 10

if has("gui_running")
  if has("gui_mac") || has("gui_macvim")
    set guifont=Menlo:h12
    set transparency=7
  endif
else
  let g:CSApprox_loaded = 1

  " IndentLine
  let g:indentLine_enabled = 1
  let g:indentLine_concealcursor = 0
  let g:indentLine_char = '┆'
  let g:indentLine_faster = 1
endif

"" Disable the blinking cursor.
set gcr=a:blinkon0
set scrolloff=3

"" Status bar
set laststatus=2

"" Use modeline overrides
set modeline
set modelines=10

set title
set titleold="Terminal"
set titlestring=%F

set statusline=%F%m%r%h%w%=(%{&ff}/%Y)\ (line\ %l\/%L,\ col\ %c)\

" Search mappings: These will make it so that going to the next one in a
" search will center on the line it's found in.
nnoremap n nzzzv
nnoremap N Nzzzv

if exists("*fugitive#statusline")
  set statusline+=%{fugitive#statusline()}
endif

" vim-airline
let g:airline_theme = 'powerlineish'
let g:airline#extensions#syntastic#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tagbar#enabled = 1
let g:airline_skip_empty_sections = 1

"*****************************************************************************
"" Abbreviations
"*****************************************************************************
"" no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" grep.vim
nnoremap <silent> <leader>f :Rgrep<CR>
let Grep_Default_Options = '-IR'
let Grep_Skip_Files = '*.log *.db'
let Grep_Skip_Dirs = '.git node_modules app/cache app/logs _build'

" terminal shortcut
nnoremap <silent> <leader>sh :terminal<CR>

"*****************************************************************************
"" Autocmd Rules
"*****************************************************************************
"" The PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
  autocmd!
  autocmd BufEnter * :syntax sync maxlines=200
augroup END

"" Remember cursor position
augroup vimrc-remember-cursor-position
  autocmd!
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

"" txt
augroup vimrc-wrapping
  autocmd!
  autocmd BufRead,BufNewFile *.txt call s:setupWrapping()
augroup END

"" make/cmake
augroup vimrc-make-cmake
  autocmd!
  autocmd FileType make setlocal noexpandtab
  autocmd BufNewFile,BufRead CMakeLists.txt setlocal filetype=cmake
augroup END

autocmd  FileType  php setlocal omnifunc=phpcomplete_extended#CompletePHP

set autoread

"*****************************************************************************
"" Mappings
"*****************************************************************************

"" Split
noremap <Leader>h :<C-u>split<CR>
noremap <Leader>v :<C-u>vsplit<CR>

"" Git
noremap <Leader>ga :Gwrite<CR>
noremap <Leader>gc :Gcommit<CR>
noremap <Leader>gsh :Gpush<CR>
noremap <Leader>gll :Gpull<CR>
noremap <Leader>gs :Gstatus<CR>
noremap <Leader>gb :Gblame<CR>
noremap <Leader>gd :Gvdiff<CR>
noremap <Leader>gr :Gremove<CR>

"" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"" Opens an edit command with the path of the currently edited file filled in
noremap <Leader>e :e <C-R>=expand("%:p:h") . "/" <CR>

"" Opens a tab edit command with the path of the currently edited file filled
noremap <Leader>te :tabe <C-R>=expand("%:p:h") . "/" <CR>

"" fzf.vim
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" The Silver Searcher
if executable('ag')
  let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
  set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
  set grepprg=rg\ --vimgrep
  command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>

" Tagbar
nmap <silent> <F4> :TagbarToggle<CR>
let g:tagbar_autofocus = 1

" Disable visualbell
set noerrorbells visualbell t_vb=
if has('autocmd')
  autocmd GUIEnter * set visualbell t_vb=
endif

"" Copy/Paste/Cut
if has('unnamedplus')
  set clipboard=unnamed,unnamedplus
endif

noremap YY "+y<CR>
noremap <leader>p "+gP<CR>
noremap XX "+x<CR>

if has('macunix')
  " pbcopy for OSX copy/paste
  vmap <C-x> :!pbcopy<CR>
  vmap <C-c> :w !pbcopy<CR><CR>
endif

"" Buffer nav
noremap <leader>z :bp<CR>
noremap <leader>q :bp<CR>
noremap <leader>x :bn<CR>
noremap <leader>w :bn<CR>

"" Close buffer
noremap <leader>c :bd<CR>

"" Clean search (highlight)
nnoremap <silent> <leader><space> :noh<cr>

"" Switching windows
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
noremap <C-h> <C-w>h

"" Vmap for maintain Visual Mode after shifting > and <
vmap < <gv
vmap > >gv

"" Open current line on GitHub
nnoremap <Leader>o :.Gbrowse<CR>

" vim-airline
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

if !exists('g:airline_powerline_fonts')
  let g:airline#extensions#tabline#left_sep = ' '
  let g:airline#extensions#tabline#left_alt_sep = '|'
  let g:airline_left_sep          = '▶'
  let g:airline_left_alt_sep      = '»'
  let g:airline_right_sep         = '◀'
  let g:airline_right_alt_sep     = '«'
  let g:airline#extensions#branch#prefix     = '⤴' "➔, ➥, ⎇
  let g:airline#extensions#readonly#symbol   = '⊘'
  let g:airline#extensions#linecolumn#prefix = '¶'
  let g:airline#extensions#paste#symbol      = 'ρ'
  let g:airline_symbols.linenr    = '␊'
  let g:airline_symbols.branch    = '⎇'
  let g:airline_symbols.paste     = 'ρ'
  let g:airline_symbols.paste     = 'Þ'
  let g:airline_symbols.paste     = '∥'
  let g:airline_symbols.whitespace = 'Ξ'
else
  let g:airline#extensions#tabline#left_sep = ''
  let g:airline#extensions#tabline#left_alt_sep = ''

  " powerline symbols
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
endif

" alchemist
let g:alchemist_tag_disable = 1

" gutentags
let g:gutentags_cache_dir = '~/.tags_cache'
let g:gutentags_ctags_exclude = ['cache/*', 'logs/*']

" deoplete
let g:deoplete#enable_at_startup = 1

" phpcd
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']

"" NERDTree configuration
let g:NERDTreeChDirMode=2
let g:NERDTreeIgnore=['\.rbc$', '\~$', '\.pyc$', '\.db$', '\.sqlite$', '__pycache__']
let g:NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\.bak$', '\~$']
let g:NERDTreeShowBookmarks=1
let g:nerdtree_tabs_focus_on_files=1
let g:NERDTreeMapOpenInTabSilent = '<RightMouse>'
let g:NERDTreeWinSize = 50
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.db,*.sqlite
nnoremap <silent> <F2> :NERDTreeFind<CR>
noremap <F3> :NERDTreeToggle<CR>
let NERDTreeShowHidden=1

" tagbar
"" elixir
let g:tagbar_type_elixir = {
    \ 'ctagstype' : 'elixir',
    \ 'kinds' : [
        \ 'f:functions',
        \ 'functions:functions',
        \ 'c:callbacks',
        \ 'd:delegates',
        \ 'e:exceptions',
        \ 'i:implementations',
        \ 'a:macros',
        \ 'o:operators',
        \ 'm:modules',
        \ 'p:protocols',
        \ 'r:records',
        \ 't:tests'
    \ ]
    \ }
"" markdown
let g:tagbar_type_markdown = {
    \ 'ctagstype' : 'markdown',
    \ 'kinds' : [
        \ 'h:Heading_L1',
        \ 'i:Heading_L2',
        \ 'k:Heading_L3'
    \ ]
    \ }

" PHPComplete extended composer path
let g:phpcomplete_index_composer_command = 'composer'

" PHP Namespace
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()
autocmd FileType php noremap <Leader>u :call PhpInsertUse()

" PHP documentator
let g:pdv_template_dir = $HOME ."/.config/nvim/plugged/pdv/templates_snip"
nnoremap <Leader>** :call pdv#DocumentWithSnip()

" undotree
nnoremap <F5> :UndotreeToggle
if has("persistent_undo")
    set undodir=~/.undodir/
    set undofile
endif

" Esc to exit from :terminal
tnoremap <Esc> <C-\><C-n>

" Limelight Goyo integration
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Goyo default
let g:goyo_width = 120

" ALE Set this. Airline will handle the rest.
let g:airline#extensions#ale#enabled = 1

" ALE quickfix instead of loclist
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1

" Define user commands for updating/cleaning the plugins.
" Each of them loads minpac, reloads .vimrc to register the
" information of plugins, then performs the task.
command! PackUpdate packadd minpac | source $MYVIMRC | call minpac#update()
command! PackClean  packadd minpac | source $MYVIMRC | call minpac#clean()
