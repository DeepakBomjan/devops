**INSERTING TEXT**

- **ESC** command mode
- **i** Insert before cursor
- **I** Insert before line
- **a** Append after cursor
- **A** Append after line
- **o** Open blank line below the cursor
- **O** Open blank line above the cursor

**QUITTING**

- **:x** Exit, saving changes
- **ZZ** Exit, saving changes
- **:wq!** Exit, saving changes
- **:q!** Wipe out your edits and quit
- **:e!** Return to the last version of the file

**MOVING**

- **h** Move left
- **j** Move down
- **k** Move up
- **l** Move right

- **w** Move to the beginning of the next word
- **W** Move to the beginning of the next blank delimited word
- **b** Move to the beginning of the previous word
- **B** Move to the beginning of the previous blank delimited word
- **e** Move to the end of the next word
- **E** Move to the end of the next blank delimited word

- **0** Move to the beginning of the line
- **$** Move to the end of the line

**CHANGING TEXT**

- **cw** To the end of a word
- **c2b** Back two words
- **c$** To the end of the line
- **C** To the end of the line
- **c0** To the beginning of the line
- **cc** The whole line
- **S** The whole line
- **r** Replace one character
- **4s** Substitute 4 characters with new text until you press **ESC**
- **4r** Replace the next 4 characters with the same character
- **4s** Replace the next 4 characters with different characters
- **R** Replace until you **ESC**

**DELETING TEXT**

- **dw** Delete a word
- **x** Delete character to the right of cursor
- **X** Delete character to the left of cursor
- **D** Delete to the end of the line
- **dd** or **:d** Delete current line

**MOVING TEXT**

- **yy** or **:y** or **Y** Yank the current line
- **p** Put the text after the cursor
- **P** Put the text before the cursor

**VISUAL MODE**

- **v** Enter visual mode and start to highlight characters
- **V** Enter visual mode and start to highlight lines
- **ESC** Exit visual mode

**OTHER**

- **~** Toggle uppercase and downcase
- **.** Repeat the last command
- **u** Undo the last command
- **U** Undo all the edits on a single line
- **CTRL+U** Redo
- **J** Join two lines

## Specify which lines to comment in vim:
```bash
:set number
:5,17s/^/#/     # this will comment out line 5-17
:%s/^/#/        # will comment out all lines in file
