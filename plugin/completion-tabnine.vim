if exists('g:loaded_completion_tabnine')
	finish
endif

let g:completion_tabnine_max_num_results = get(g:, 'completion_tabnine_max_num_results', 7)
let g:completion_tabnine_line_limit = get(g:, 'completion_tabnine_line_limit', 1000)
let g:completion_tabnine_sort_by_details = get(g:, 'completion_tabnine_sort_by_details', 0)

lua require'completion-tabnine'.init()
