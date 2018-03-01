" alchemist
let g:alchemist_tag_disable = 1

" gutentags
let g:gutentags_cache_dir = '~/.tags_cache'
let g:gutentags_ctags_exclude = ['cache/*', 'logs/*']

" deoplete
let g:deoplete#enable_at_startup = 1

let test#elixir#exunit#executable = 'docker-compose run web mix test'

" Limelight Goyo integration
autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" Goyo default
let g:goyo_width = 120

