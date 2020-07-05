if exists('g:loaded_completion_tabnine')
	finish
endif

lua require'completion-tabnine'.init()
