if exists('g:loaded_completion_tabnine')
	finish
endif

let g:loaded_completion_tabnine = 1
let g:completion_tabnine_max_num_results = get(g:, 'completion_tabnine_max_num_results', 7)
let g:completion_tabnine_max_lines = get(g:, 'completion_tabnine_max_lines', 1000)
let g:completion_tabnine_sort_by_details = get(g:, 'completion_tabnine_sort_by_details', 0)
let g:completion_tabnine_priority = get(g:, 'completion_tabnine_priority', 0)
if has("mac")
  let g:completion_tabnine_tabnine_path = get(g:, 'completion_tabnine_tabnine_path', expand("<sfile>:p:h:h") .. "/binaries/TabNine_Darwin")
elseif has('unix')
  let g:completion_tabnine_tabnine_path = get(g:, 'completion_tabnine_tabnine_path', expand("<sfile>:p:h:h") .. "/binaries/TabNine_Linux")
elseif has('win32') || has('win64')
  let g:completion_tabnine_tabnine_path = get(g:, 'completion_tabnine_tabnine_path', expand("<sfile>:p:h:h") .. "/binaries/TabNine_Windows")
endif

autocmd VimEnter * lua require'completion-tabnine'.register()
