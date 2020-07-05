
completion-tabnine
==================

A **TabNine** completion source for [completion-nvim](https://github.com/haorenW1025/completion-nvim)

![capture](./capture.png)

### Install

vim-plug
```
Plug 'aca/tabnine-completion', { 'do': './install.sh' }
```

vimrc
```
" vimrc
let g:completion_chain_complete_list = {
    \ 'default': [
    \    {'complete_items': ['lsp', 'snippet', 'tabnine' ]},
    \    {'mode': '<c-p>'},
    \    {'mode': '<c-n>'}
    \]
\}
```

### TODO
Any help would be greatly appreciated!

- [ ] Better Scoring Rules based on TabNine Score, fuzzy matching
- [ ] Docs
- [ ] Configuration
- [ ] Error Handling

