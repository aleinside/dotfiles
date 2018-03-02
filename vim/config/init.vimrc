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

" install minpac
" git clone https://github.com/k-takata/minpac.git ~/.config/nvim/pack/minpac/opt/minpac

if exists('*minpac#init')
  " minpac is loaded
  call minpac#init()

  """ DUBBI
  " insert mode auto-completion for quotes, parens, brackets, etc.
  "call minpac#add('Raimondi/delimitMate') " mmm
  "" Snippets
  "Plug 'SirVer/ultisnips'
  "Plug 'honza/vim-snippets'
  "call minpac#add('altercation/vim-colors-solarized')
  " php
  "call minpac#add('lvht/phpcd.vim')
  "" symfony
  "call minpac#add('docteurklein/vim-symfony')
  " PHP autocomplete
  "call minpac#add('shawncplus/phpcomplete.vim')
  " PHPcomplete
  "call minpac#add('m2mdas/phpcomplete-extended')
  " PHPcomplete symfony
  "call minpac#add('m2mdas/phpcomplete-extended-symfony')
  " PHP documentator
  "call minpac#add('tobys/pdv')
  " Mustache template system (per pdv)
  "call minpac#add('tobys/vmustache')
  " unload, delete or wipe a buffer without closing the window or split
  "call minpac#add('qpkorr/vim-bufkill')
  " formatting
  "call minpac#add('sbdchd/neoformat')

  """" GENERAL
  call minpac#add('k-takata/minpac', {'type': 'opt'})
  " advanced syntax vim script
  call minpac#add('vim-jp/syntax-vim-ex')
  " trailing whitespace
  call minpac#add('bronson/vim-trailing-whitespace')
  " language pack
  call minpac#add('sheerun/vim-polyglot')
  " comment stuff out
  call minpac#add('tpope/vim-commentary')
  " async lint engine
  call minpac#add('w0rp/ale')
  " manages tag files
  call minpac#add('ludovicchabant/vim-gutentags')
  let g:make = 'gmake'
  if exists('make')
    let g:make = 'make'
  endif
  call minpac#add('Shougo/vimproc.vim', {'do': g:make})
  " dark powered neo-completion
  call minpac#add('Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' })
  " dark powered plugin for Neovim/Vim to unite all interfaces
  call minpac#add('Shougo/denite.nvim')
  " Vim sugar for the UNIX shell commands that need it the most
  call minpac#add('tpope/vim-eunuch')
  " bookmarks
  call minpac#add('MattesGroeger/vim-bookmarks')
  " session
  call minpac#add('tpope/vim-obsession')
  " undo history visualizer
  call minpac#add('mbbill/undotree')
  " multiple cursors
  call minpac#add('terryma/vim-multiple-cursors')
  " Delete buffers and close files in Vim without closing your windows or messing up your layou
  call minpac#add 'moll/vim-bbye'
  """ GIT
  " git wrapper
  call minpac#add('tpope/vim-fugitive')
  " git diff
  call minpac#add('jreybert/vimagit')
  " git diff in gutter
  call minpac#add('airblade/vim-gitgutter')
  " github for fugitive
  call minpac#add('tpope/vim-rhubarb')

  """ GUI
  " status tabline
  call minpac#add('vim-airline/vim-airline')
  " status tabline themes
  call minpac#add('vim-airline/vim-airline-themes')
  " tagbar
  call minpac#add('majutsushi/tagbar')
  " Startify
  call minpac#add('mhinz/vim-startify')
  " distraction free writing
  call minpac#add('junegunn/goyo.vim')
  " hyperfocus-writing
  call minpac#add('junegunn/limelight.vim')
  " physics-based smooth scrolling
  call minpac#add('yuttie/comfortable-motion.vim')
  " nerdtree
  call minpac#add('scrooloose/nerdtree')
  call minpac#add('jistr/vim-nerdtree-tabs')
  " icons for NERDTree
  call minpac#add('ryanoasis/vim-devicons')

  """ SEARCH
  " grep search tools
  call minpac#add('vim-scripts/grep.vim')
  " fuzzy finder
  call minpac#add('junegunn/fzf', {'dir': '~/.fzf', 'do': '!./install --all'})
  call minpac#add('junegunn/fzf.vim')

  """ COLOR SCHEME
  " gvim-only colorschemes work in terminal vim
  call minpac#add('vim-scripts/CSApprox')
  " display the indention levels with thin vertical lines
  call minpac#add('Yggdroot/indentLine')
  call minpac#add('tomasr/molokai')

  """ LANGUAGES
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

  " python
  "" Python Bundle
  call minpac#add('davidhalter/jedi-vim')
  call minpac#add('raimon49/requirements.txt.vim', {'for': 'requirements'})

  " markdown
  call minpac#add('plasticboy/vim-markdown')
  call minpac#add('jtratner/vim-flavored-markdown')

  " elixir
  call minpac#add('slashmili/alchemist.vim')
  call minpac#add('c-brenn/phoenix.vim')

  " php
  " PHP namespace
  call minpac#add('arnaud-lb/vim-php-namespace', {'for': 'php'})
  " PHP vim syntax
  call minpac#add('StanAngeloff/php.vim')

  "call minpac#add('stephpy/vim-php-cs-fixer')

  "call minpac#add('roxma/nvim-completion-manager')

  "call minpac#add('phpactor/phpactor', {'do': 'composer install'})
  "call minpac#add('roxma/ncm-phpactor')
  "call minpac#add('arnaud-lb/vim-php-namespace')

  " php autocompletion engine and tools
  "call minpac#add('nishigori/vim-php-dictionary')
  "call minpac#add('phpstan/vim-phpstan')

  " php doc autocompletion
  "call minpac#add('tobyS/vmustache')
  "call minpac#add('tobyS/pdv')

  " refactoring options
  "call minpac#add('adoy/vim-php-refactoring-toolbox')
  "call minpac#add('2072/php-indenting-for-vim')

  " twig
  call minpac#add('evidens/vim-twig')

  " docker
  call minpac#add('infoslack/vim-docker')
endif

