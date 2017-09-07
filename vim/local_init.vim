" nerd font
set encoding=utf8
let g:airline_powerline_fonts = 1

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

" NERDTree
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

" PHP Namespace
function! IPhpInsertUse()
    call PhpInsertUse()
    call feedkeys('a',  'n')
endfunction
autocmd FileType php inoremap <Leader>u <Esc>:call IPhpInsertUse()
autocmd FileType php noremap <Leader>u :call PhpInsertUse()

function! IPhpExpandClass()
    call PhpExpandClass()
    call feedkeys('a', 'n')
endfunction
autocmd FileType php inoremap <Leader>i <Esc>:call IPhpExpandClass()
autocmd FileType php noremap <Leader>i :call PhpExpandClass()

" PHP documentator
let g:pdv_template_dir = $HOME ."/.config/nvim/plugged/pdv/templates_snip"
nnoremap <Leader>** :call pdv#DocumentWithSnip()

" undotree
nnoremap <F5> :UndotreeToggle
