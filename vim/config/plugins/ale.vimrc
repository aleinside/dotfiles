let g:ale_fixers = {
\   'php': ['php_cs_fixer', 'phpcbf', 'remove_trailing_lines', 'trim_whitespace'],
\   'elm': ['elm-format', 'remove_trailing_lines', 'trim_whitespace'],
\   'elixir': ['mix_format', 'remove_trailing_lines', 'trim_whitespace'],
\}

let g:ale_fix_on_save = 1

