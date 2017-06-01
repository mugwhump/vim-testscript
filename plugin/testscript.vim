"This file's run when vim is opened, when the command in your vimrc to load
"the plugin is executed. Thus any variables used by this script (like <leader>
"or tsReplaceDoubleSlash should be set before the line that loads the plugin.
"It's used to map shortcuts that should be available for all filetypes.
" Most actual functionality is loaded on demand by autoload/testscript.vim


" ---------------- Assign shortcuts
" User can set g:auto_map_testscript_keys to 0 to use their own mappings
if !exists('g:auto_map_testscript_keys')
    let g:auto_map_testscript_keys = 1
endif

if g:auto_map_testscript_keys
    nnoremap <silent> <leader>fu :call testscript#FindUsesOfCurrentFile()<CR>
    nnoremap <silent> <leader>s :call testscript#SwitchTcAndCsv()<CR>
    nnoremap <silent> <leader>t :call testscript#PromptOpenTCNum()<CR>
    nnoremap <silent> <leader>os :call testscript#OpenSpira()<CR>
    nnoremap <silent> <leader>vco :call testscript#CheckoutCurrentFile()<CR>
    nnoremap <silent> <leader>vci :call testscript#CheckinCurrentFile()<CR>
    nnoremap <silent> <leader>vca :call testscript#AddCurrentFile()<CR>
    nnoremap <silent> <leader>vcu :call testscript#UpdateWorkspace()<CR>
endif

" Create menu items for shortcuts
let leader = escape( exists('g:mapleader') ? g:mapleader : '\', '\' )
exec "anoremenu <silent> TestScript.Find\\ scripts\\ Using\\ current\\ file<Tab>".leader."fu :call testscript#FindUsesOfCurrentFile()<CR>"
exec "anoremenu <silent> TestScript.Switch\\ \\.ts\\ &&\\ \\.csv<Tab>".leader."s :call testscript#SwitchTcAndCsv()<CR>"
exec "anoremenu <silent> TestScript.open\\ Tc<Tab>".leader."t :call testscript#PromptOpenTCNum()<CR>"
exec "anoremenu <silent> TestScript.Open\\ Spira\\ for\\ tc<Tab>".leader."os :call testscript#OpenSpira()<CR>"
exec "anoremenu <silent> Version\\ Control.Check\\ Out<Tab>".leader."vco :call testscript#CheckoutCurrentFile()<CR>"
exec "anoremenu <silent> Version\\ Control.Check\\ In<Tab>".leader."vci :call testscript#CheckinCurrentFile()<CR>"
exec "anoremenu <silent> Version\\ Control.Add\\ file<Tab>".leader."vca :call testscript#AddCurrentFile()<CR>"
exec "anoremenu <silent> Version\\ Control.Update\\ workspace<Tab>".leader."vcu :call testscript#UpdateWorkspace()<CR>"
amenu <silent> TestScript.Help<Tab>:tab\ h\ testscript :tab h testscript<CR>

" Create tooltips for the menu items
tmenu TestScript.Find\ scripts\ Using\ current\ file Searches for .ts scripts that use the current .ts or .csv file in an ExecuteScript statement.
tmenu TestScript.Switch\ \.ts\ &&\ \.csv If a .ts file is open, opens its matching .csv, and vice-versa.
tmenu TestScript.open\ Tc Opens a Test Case by number.
tmenu TestScript.Open\ Spira\ for\ tc Opens spira page for current TC. If no TC is open, prompts for TC number.
tmenu Version\ Control.Check\ Out Checks the current file out in tfs.
tmenu Version\ Control.Check\ In Check files in in tfs.
tmenu Version\ Control.Add\ file Adds new files to tfs.
tmenu Version\ Control.Update\ workspace Updates workspace from tfs.
tmenu TestScript.Help Opens the help file for the testscript plugin.

" ----------------- auto-expand '//' in testscript files into %DOUBLESLASH%
"  when inside a string.
if !exists('g:tsReplaceDoubleSlash') || tsReplaceDoubleSlash == 1
    autocmd FileType testscript :inoremap <buffer> <silent>// <esc>:call ExpandDoubleSlash()<CR>a
endif
function! ExpandDoubleSlash()
	let syntux = testscript#CurrentSyntax()
	" After this function runs, we don't know where col pos came from. 1st 2
	" cols end up in col 1... so it ducks up in column 2.
	let insertKey = ( col(".") == 1 ) ? "i" : "a"
	if syntux == "String" || syntux == "Identifier"
		:exec "normal! " . insertKey . "%DOUBLESLASH%"
	else
		:exec "normal! " . insertKey . "//"
		
	endif
endfunction

