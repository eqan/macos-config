set updatetime=300
set scroll=15
set timeoutlen=100
set number relativenumber
set clipboard=unnamedplus

imap [] <Esc>
imap kj <Esc>
nmap R <c-n>:%s///g<left><left>

nnoremap <C-w> <Cmd>call VSCodeNotify('workbench.action.closeActiveEditor')<CR>
