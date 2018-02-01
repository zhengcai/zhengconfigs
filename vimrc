set showmode
set number
"cursor down/up existing lines
imap <S-Down> _<Esc>mz:set ve=all<CR>i<Down>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>
imap <S-Up> _<Esc>mz:set ve=all<CR>i<Up>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>
"cursor down with a new line
imap <S-CR> _<Esc>mz:set ve=all<CR>o<C-o>`z<Down>_<Esc>my`zi<Del><Esc>:set ve=<CR>`yi<Del>