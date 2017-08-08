" set encoding=utf8
" set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types:h11
" let g:airline_powerline_fonts = 1

" alchemist
let g:alchemist_tag_disable = 1

" gutentags
let g:gutentags_cache_dir = '~/.tags_cache'

" neomake
autocmd! BufWritePost * Neomake
let g:neomake_elixir_enabled_makers = ['mix', 'credo', 'dogma']

" deoplete
let g:deoplete#enable_at_startup = 1

" phpcd
let g:deoplete#ignore_sources = get(g:, 'deoplete#ignore_sources', {})
let g:deoplete#ignore_sources.php = ['omni']

" searchtask
let g:searchtasks_list=["TODO", "FIXME", "XXX"]
