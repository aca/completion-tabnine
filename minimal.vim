call plug#begin(expand('~/src/vim/plug')) " change this to your plug directory
    Plug 'neovim/nvim-lsp'
    Plug 'nvim-lua/completion-nvim'
    Plug 'aca/completion-tabnine' , { 'do': './install.sh' }
call plug#end()

set updatetime=300
set completeopt=menuone,noinsert,noselect
set shortmess+=cF

let g:completion_matching_strategy_list = ['all']

let g:completion_chain_complete_list = {
    \ 'default': [
    \    {'complete_items': ['tabnine']},
    \    {'mode': '<c-p>'},
    \    {'mode': '<c-n>'}
    \]
\}

" let g:completion_enable_auto_popup = 1
let g:completion_timer_cycle = 80

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

let g:completion_matching_ignore_case = 1
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ completion#trigger_completion()
let g:completion_confirm_key = ""
imap <expr> <cr>  pumvisible() ? complete_info()["selected"] != "-1" ?
                 \ "\<Plug>(completion_confirm_completion)"  : "\<c-e>\<CR>" :  "\<CR>"

autocmd BufEnter * lua require'completion'.on_attach()
