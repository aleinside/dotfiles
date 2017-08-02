
# VIM

`i` → Insert mode. Type ESC to return to Normal mode.

`x` → Delete the char under the cursor

`:wq` → Save and Quit (:w save, :q quit)

`dd` → Delete (and copy) the current line

`p` → Paste

`hjkl` (highly recommended but not mandatory) → basic cursor move (←↓↑→). Hint: j looks like a down arrow.

`:help <command>` → Show help about <command>. You can use :help without a <command> to get general help.

### Insert mode variations

`a` → insert after the cursor

`o` → insert a new line after the current one

`O` → insert a new line before the current one

`cw` → replace from the cursor to the end of the word

### Basic moves

`0` → go to the first column

`^` → go to the first non-blank character of the line

`$` → go to the end of line

`g_` → go to the last non-blank character of line

`/pattern` → search for pattern

### Copy/Paste

`P` → paste before, remember p is paste after current position.

`yy` → copy the current line, easier but equivalent to ddP

### Undo/Redo

`u` → undo

`<C-r>` → redo

### Load/Save/Quit/Change File (Buffer)

`:e <path/to/file>` → open

`:w` → save

`:saveas <path/to/file>` → save to <path/to/file>

`:x`, `ZZ` or `:wq` → save and quit (`:x` only save if necessary)

`:q!` → quit without saving, also: `:qa!` to quit even if there are modified hidden buffers.

`:bn` (resp. `:bp`) → show next (resp. previous) file (buffer)

### Moves

`NG` → Go to line N

`gg` → shortcut for 1G - go to the start of the file

`G` → Go to last line

### Word moves

`w` → go to the start of the following word,

`e` → go to the end of this word.

`W` → go to the start of the following WORD,

`E` → go to the end of this WORD.

![word_moves](http://yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/word_moves.jpg)

`%` : Go to the corresponding (, {, [.

`*` (resp. `#`) : go to next (resp. previous) occurrence of the word under the cursor

### Line moves

`0` → go to column 0

`^` → go to first character on the line

`$` → go to the last column

`g_` → go to the last character on the line

`fa` → go to next occurrence of the letter a on the line. , (resp. `;`) will find the next (resp. previous) occurrence.

`t`, → go to just before the character ,.

`3fa` → find the 3rd occurrence of a on this line.

`F` and `T` → like f and t but backward.

![line_moves](http://yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/line_moves.jpg)

`dt"` → remove everything until the ".

### Text objects

Suppose the cursor is on the first `o` of `(map (+) ("foo"))`

`vi"` → will select `foo`

`va"` → will select `"foo"`

`vi)` → will select `"foo"`

`va)` → will select `("foo")`

`v2i)` → will select `map (+) ("foo")`

`v2a)` → will select `(map (+) ("foo"))`

![textobjects](http://yannesposito.com/Scratch/img/blog/Learn-Vim-Progressively/textobjects.png)

### Rectangular blocks

Rectangular blocks are very useful for commenting many lines of code. Typically: `0<C-v><C-d>I-- [ESC]`

- `^` → go to the first non-blank character of the line
- `<C-v>` → Start block selection
- `<C-d>` → move down (could also be `jjj` or `%`, etc…)
- `I-- [ESC]` → write -- to comment each line

### Completion

`<C-p>` → completion

### Visual selection

We saw an example with `<C-v>`. There is also `v` and `V`. Once the selection has been made, you can:

`J` → join all the lines together.

`<` (resp. `>`) → indent to the left (resp. to the right).

`=` → auto indent

Add something at the end of all visually selected lines:

- `<C-v>`
- go to desired line (`jjj` or `<C-d>` or `/pattern` or `%` etc…)
- `$` go to the end of the line
- `A`, write text, `ESC`.

### Splits

These are the most important commands, but you should look at `:help split`.

`:split` → create a split (`:vsplit` create a vertical split)
`<C-w><dir>` : where dir is any of hjkl or ←↓↑→ to change the split.
`<C-w>_` (resp. `<C-w>|`) : maximise the size of the split (resp. vertical split)
`<C-w>+` (resp. `<C-w>-`) : Grow (resp. shrink) split

## Vim Bootstrap

Commands | Descriptions
--- | ---
`:cd <path>` | Open path */path*
<kbd>Ctrl</kbd><kbd>w</kbd>+<kbd>h</kbd><kbd>j</kbd><kbd>k</kbd><kbd>l</kbd> | Navigate via split panels
<kbd>Ctrl</kbd><kbd>w</kbd><kbd>w</kbd> | Alternative navigate vim split panels
<kbd>,</kbd><kbd>.</kbd> | Set path working directory
<kbd>,</kbd><kbd>w</kbd> or <kbd>,</kbd><kbd>x</kbd> | Next buffer navigate
<kbd>,</kbd><kbd>q</kbd> or <kbd>,</kbd><kbd>z</kbd> | previous buffer navigate
<kbd>shift</kbd><kbd>t</kbd> | Create a tab
<kbd>tab</kbd> | next tab navigate
<kbd>shift</kbd><kbd>tab</kbd> | previous tab navigate
<kbd>,</kbd><kbd>e</kbd> | Find and open files
<kbd>,</kbd><kbd>b</kbd> | Find file on buffer (open file)
<kbd>,</kbd><kbd>c</kbd> | Close active buffer (clone file)
<kbd>F2</kbd>  | Open tree navigate in actual opened file
<kbd>F3</kbd>  | Open/Close tree navigate files
<kbd>F4</kbd> | List all class and method, support for python, go, lua, ruby and php
<kbd>,</kbd><kbd>v</kbd> | Split vertical
<kbd>,</kbd><kbd>h</kbd> | Split horizontal
<kbd>,</kbd><kbd>f</kbd> | Search in the project
<kbd>,</kbd><kbd>o</kbd> | Open github file/line (website), if used git in **github**
<kbd>,</kbd><kbd>s</kbd><kbd>h</kbd> | Open shell.vim terminal inside Vim or NeoVim built-in terminal
<kbd>,</kbd><kbd>g</kbd><kbd>a</kbd> | Execute *git add* on current file
<kbd>,</kbd><kbd>g</kbd><kbd>c</kbd> | git commit (splits window to write commit message)
<kbd>,</kbd><kbd>g</kbd><kbd>s</kbd><kbd>h</kbd> | git push
<kbd>,</kbd><kbd>g</kbd><kbd>l</kbd><kbd>l</kbd> | git pull
<kbd>,</kbd><kbd>g</kbd><kbd>s</kbd> | git status
<kbd>,</kbd><kbd>g</kbd><kbd>b</kbd> | git blame
<kbd>,</kbd><kbd>g</kbd><kbd>d</kbd> | git diff
<kbd>,</kbd><kbd>g</kbd><kbd>r</kbd> | git remove
<kbd>,</kbd><kbd>s</kbd><kbd>o</kbd> | Open Session
<kbd>,</kbd><kbd>s</kbd><kbd>s</kbd> | Save Session
<kbd>,</kbd><kbd>s</kbd><kbd>d</kbd> | Delete Session
<kbd>,</kbd><kbd>s</kbd><kbd>c</kbd> | Close Session
<kbd>></kbd> | indent to right
<kbd><</kbd> | indent to left
<kbd>g</kbd><kbd>c</kbd> | Comment or uncomment lines that {motion} moves over
<kbd>Y</kbd><kbd>Y</kbd> | Copy to clipboard
<kbd>,</kbd><kbd>p</kbd> | Paste
<kbd>Ctrl</kbd><kbd>y</kbd> + <kbd>,</kbd> | Activate Emmet plugin

## Alchemist

`<C-]>` → Jump to the definition, while cursor is under the keyword in NORMAL mode

`<C-T>` → Jump through tag stack, jump between tag stack in NORMAL mode.


### ExDoc

`ExDoc [module/function]` → provides document (press TAB to get autocomplete)

### ExDef

`ExDef [module/function]` → jumps to the definition.

### IEx

`IEx [command]` → opens a new IEx session if none exists (iex -S mix). If one already exists, it switches to that window (or reopens the window if it was closed). can take a command, which it will run. For example: :IEx h Enum.reverse

`IExHide` → hides the window that the IEx session is in

### Mix

`Mix [command]` → run mix command (press `TAB` to get commands autocomplete)

# TMUX

Custom configuration: `C-b` → `C-a`

`M` → Meta (Alt)

### Panes

`C-b -` → split vertical (orig %)

`C-b |` → split horizontal (orig ")

`M <arrow key>` → navigating panes (orig `C-b <arrow key>`)

`Ctrl-d` → (or type `exit`) close pane

### Window

`C-b c` → create window

`C-b p` → switch previous window

`C-b n` → switch next window

`C-b <number>` → switch window

### Session

`C-b d` → detach session

`C-b D` → tmux give you a choice which of your sessions you want to detach

`tmux ls` → list session

`tmux attach -t 0` → attach to session 0

`tmux new -s database` → start new session with name `database`

`tmux rename-session -t 0 database` → rename session 0 in `database`

### Extra

`C-b ?` → list of all avaible commands

`C-b z` → make a pane go full screen. Hit `C-b z` again to shrink it back to its previous size

`C-b C-<arrow key>` → resize pane in direction of <arrow key>

`C-b ,` → rename the current window

`C-b r` → reload config file (orig `C-b :source-file ~/.tmux.conf`)

### Scroll

`C-b [` → you can use your normal navigation keys to scroll around
