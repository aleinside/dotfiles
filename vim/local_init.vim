" nerd font
" set encoding=utf8
" set guifont=Droid\ Sans\ Mono\ Nerd\ Font\ Complete\ 11
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

" vimux vimix
" let g:vimix_map_keys = 1
" let g:vimix_mix_command = "docker-compose run web iex -S mix"

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
