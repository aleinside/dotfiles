" For a paranoia.
" Normally `:set nocp` is not needed, because it is done automatically
" when .vimrc is found.
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

"" Map leader to ,
let mapleader=','

let vimplug_exists=expand('~/.config/nvim/autoload/plug.vim')

let g:vim_bootstrap_langs = "elixir,elm,html,javascript,php,python"
let g:vim_bootstrap_editor = "nvim"				" nvim or vim

if !filereadable(vimplug_exists)
  if !executable("curl")
    echoerr "You have to install curl or first install vim-plug yourself!"
    execute "q!"
  endif
  echo "Installing Vim-Plug..."
  echo ""
  silent !\curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let g:not_finish_vimplug = "yes"

  autocmd VimEnter * PlugInstall
endif

" Required:
call plug#begin(expand('~/.config/nvim/plugged'))

"" Snippets
"Plug 'SirVer/ultisnips'
"Plug 'honza/vim-snippets'
" PHP documentator
"Plug 'tobys/pdv'
" Mustache template system (per pdv)
"Plug 'tobys/vmustache'
" unload, delete or wipe a buffer without closing the window or split
"Plug 'qpkorr/vim-bufkill'

"""" GENERAL
" advanced syntax vim script
Plug 'vim-jp/syntax-vim-ex'
" json
Plug 'elzr/vim-json'
" trailing whitespace
Plug 'bronson/vim-trailing-whitespace'
" language pack
Plug 'sheerun/vim-polyglot'
" comment stuff out
Plug 'tpope/vim-commentary'
" async lint engine
Plug 'w0rp/ale'
" manages tag files
Plug 'ludovicchabant/vim-gutentags'
let g:make = 'gmake'
if exists('make')
  let g:make = 'make'
endif
Plug 'Shougo/vimproc.vim', {'do': g:make}
" dark powered neo-completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" dark powered plugin for Neovim/Vim to unite all interfaces
Plug 'Shougo/denite.nvim'
" Vim sugar for the UNIX shell commands that need it the most
Plug 'tpope/vim-eunuch'
" bookmarks
Plug 'MattesGroeger/vim-bookmarks'
" session
Plug 'tpope/vim-obsession'
" undo history visualizer
Plug 'mbbill/undotree'
" multiple cursors
Plug 'terryma/vim-multiple-cursors'
" Delete buffers and close files in Vim without closing your windows or messing up your layou
Plug 'moll/vim-bbye'
""" GIT
" git wrapper
Plug 'tpope/vim-fugitive'
" git diff
Plug 'jreybert/vimagit'
" git diff in gutter
Plug 'airblade/vim-gitgutter'
" github for fugitive
Plug 'tpope/vim-rhubarb'

""" GUI
" status tabline
Plug 'vim-airline/vim-airline'
" status tabline themes
Plug 'vim-airline/vim-airline-themes'
" tagbar
Plug 'majutsushi/tagbar'
" Startify
Plug 'mhinz/vim-startify'
" distraction free writing
Plug 'junegunn/goyo.vim'
" hyperfocus-writing
Plug 'junegunn/limelight.vim'
" physics-based smooth scrolling
Plug 'yuttie/comfortable-motion.vim'
" nerdtree
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
" icons for NERDTree
Plug 'ryanoasis/vim-devicons'

""" SEARCH
" grep search tools
Plug 'vim-scripts/grep.vim'
" fuzzy finder
if isdirectory('/usr/local/opt/fzf')
  Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
endif

""" COLOR SCHEME
" gvim-only colorschemes work in terminal vim
Plug 'vim-scripts/CSApprox'
" display the indention levels with thin vertical lines
Plug 'Yggdroot/indentLine'
Plug 'tomasr/molokai'

""" PROSE
Plug 'reedes/vim-pencil'

""" LANGUAGES
" elixir
Plug 'elixir-editors/vim-elixir'
Plug 'carlosgaldino/elixir-snippets'

" elm
"" Elm Bundle
Plug 'elmcast/elm-vim'

" html
"" HTML Bundle
Plug 'hail2u/vim-css3-syntax'
Plug 'gorodinskiy/vim-coloresque'
Plug 'tpope/vim-haml'
Plug 'mattn/emmet-vim'

" javascript
"" Javascript Bundle
Plug 'jelera/vim-javascript-syntax'

" python
"" Python Bundle
Plug 'davidhalter/jedi-vim'
Plug 'raimon49/requirements.txt.vim', {'for': 'requirements'}

" markdown
Plug 'plasticboy/vim-markdown'
Plug 'jtratner/vim-flavored-markdown'

" elixir
Plug 'slashmili/alchemist.vim'
Plug 'c-brenn/phoenix.vim'

" php
" PHP namespace
Plug 'arnaud-lb/vim-php-namespace', {'for': 'php'}
" PHP vim syntax
Plug 'StanAngeloff/php.vim'
" php cs fixer
"Plug 'stephpy/vim-php-cs-fixer'
" php namespace
Plug 'arnaud-lb/vim-php-namespace'

"Plug 'roxma/nvim-completion-manager'

"Plug 'phpactor/phpactor', {'do': 'composer install'}
"Plug 'roxma/ncm-phpactor'

" php autocompletion engine and tools
"Plug 'nishigori/vim-php-dictionary'
"Plug 'phpstan/vim-phpstan'

" php doc autocompletion
"Plug 'tobyS/vmustache'
"Plug 'tobyS/pdv'

" refactoring options
"Plug 'adoy/vim-php-refactoring-toolbox'
"Plug '2072/php-indenting-for-vim'

" twig
Plug 'evidens/vim-twig'

" docker
Plug 'infoslack/vim-docker'

" neoformat
"Plug 'sbdchd/neoformat'

call plug#end()

" Declare the general config group for autocommand
augroup vimrc
  autocmd!
augroup END
