" This file is loaded when needed by functions prefaced with testscript.
" Ex) call testscript#OpenTs()
" Most of the plugin's functionality is here.

" Check that required variables have been defined by user
if !exists("g:tsReferenceFile")
    let tsReferenceFile = fnameescape(expand("<sfile>:p:h:h") . "/txt/QAPlayer_Scripting_Language_Syntax.txt")
    if !filereadable(tsReferenceFile)
        echoerr "Error in testscript plugin: unable to find QAPlayer Syntax reference file at path: " . tsReferenceFile .
                    \" Execute ':help tsReferenceFile' for more info."
    endif
endif

if !exists("g:tsSpiraURL")
    let tsSpiraURL = "http://spiratest/SpiraTest/46/TestCase/"
endif

if !exists("g:tsVariableSearchPrefix")
    let tsVariableDefiningStatements = "SetVariable|SetDateVariable|SetIntegerVariable|SplitToVariable|SetRandomNumberToVariable|
                \SetRandomStringToVariable|SetFileVariable|SetBinGuidVariable|SetBinGuidVariableFromBin|CreateArrayVar|
                \GetWebText(\\s+\\S+){1}|IsWebElementPresent(\\s+\\S+){4}"
endif

if !exists("g:tsProjectFolder")
    let tsProjectFolder = "tsProjectFolder gives the path to the root folder of your project. All your test script files should be found under it."
    echoerr "Error in testscript plugin: undefined variable tsProjectFolder. " . tsProjectFolder . " Please define this variable in your vimrc."
endif

if !exists("g:tsTfsExePath")
    let tsTfsExePath = "tsTfsExePath is the path to TF.exe, the program that lets you do version control from the command line. It might be found at this path: C:/Program Files (x86)/Microsoft Visual Studio 11.0/Common7/IDE/TF.exe"
    echoerr "Error in testscript plugin: undefined variable tsTfsExePath. " . tsTfsExePath . " Please define this variable in your vimrc."
endif

" ------------------- Jump to Script

"This block indexes all the .ts and .csv files in the project folder
if !exists("loaded_testscripts")
	"Contains full path of each script
	let tsScriptPaths = split( globpath(tsProjectFolder, "**/*.ts"), "\n" )
	let g:tsScripts = {}
	for s in tsScriptPaths
		let g:tsScripts[ fnamemodify(s, ":t:r") ] = s " Filename without extension
	endfor
    "Now load all csvs in a separate dictionary
	let tsCsvPaths = split( globpath(tsProjectFolder, "**/*.csv"), "\n" )
	let g:tsCsvs = {}
	for s in tsCsvPaths
		let g:tsCsvs[ fnamemodify(s, ":t:r") ] = s " Filename without extension
	endfor
endif
let loaded_testscripts = 1

function! testscript#OpenTs()
    let line = substitute( getline('.'), '^\s*\/\/\(.\{-}\)', '\1', '' )
    let currentLineWords = split(line)
    if len(currentLineWords) > 1 && currentLineWords[0] == "ExecuteScript"
        let script = currentLineWords[1]
        let path = get(g:tsScripts, script, "failu")
        if path == "failu"
            :echo "Cannot locate script " . script
        else
            :silent exec "tab drop " . path  
        endif
    endif
endfunction

function! testscript#OpenCsv()
    let line = substitute( getline('.'), '^\s*\/\/\(.\{-}\)', '\1', '' )
    let currentLineWords = split(line)
    if len(currentLineWords) > 3 && currentLineWords[0] == "ExecuteScript"
        let script = currentLineWords[3]
        let path = get(g:tsCsvs, script, "failu")
        if path == "failu"
            :echo "Cannot locate csv " . script
        else
            :silent exec "tab drop " . path  
        endif
    endif
endfunction

" ------------- Search for scripts that execute current .ts or .csv file
function! testscript#FindUsesOfCurrentFile()
    let fname = expand("%:t:r") 
    let ext = expand("%:p:e")
    if ext == "ts"
        :noautocmd exec "vimgrep '\\v^\\s*(ExecuteScript|ExecuteScriptIfError)\\s+" . fname . "'j " . g:tsProjectFolder . "/**/*.ts | copen"
    elseif ext == "csv"
        :noautocmd exec "vimgrep '\\v^\\s*(ExecuteScript|ExecuteScriptIfError)\\s+\\S+\\s+\\S+\\s+" . fname . "'j " . g:tsProjectFolder . "/**/*.ts | copen"
    else
        :echo "Current filetype is ." . ext . ". Use this function with a .ts or .csv file open to find scripts in your project that use the current .ts or .csv file."
    endif
endfunction

" ------------- Search for definition of variable
function! GetCurrentBigWord()
    let oldIsKeyword = &iskeyword
    let &iskeyword = "!,#,$,38-126" " Everything besides quote and %
    let cword = expand("<cword>")
    let &iskeyword = oldIsKeyword
    return cword
endfunction

function! testscript#FindVariable()
    let cword = GetCurrentBigWord()
    :noautocmd exec "vimgrep '\\v\\s*(" . g:tsVariableDefiningStatements . ")\\s+\\M" . cword . "\\v(\\s|$)'j " .g:tsProjectFolder."/**/*.ts"
    let qflist = getqflist()
    if qflist == []
        echoerr "Couldn't find definition for " . cword . ". Was it defined by a different type of statement? (See :help tsVariableDefiningStatements)"
    else
        :silent copen
    endif
endfunction

" ------------- Reference
function! testscript#CurrentSyntax()
    return synIDattr(synID(line("."),col("."),1),"name")
endfunction

function! TestReference(arg)
	"tab drop opens file in new tab, or uses current tab
    "\%xa0 searches for unicode no-break spaces, too
	:exec "let @/='^" . a:arg . "\\(\\s\\|\\%xa0\\)*$'|tab drop " . g:tsReferenceFile . "|silent setlocal wrap |silent normal! n<CR>"
endfunction

function! OpenReferenceForCurrentWord()
    let syntux = CurrentSyntax()
    if syntux == "Function"
        let curWord = expand("<cword>")
        call TestReference(curWord)
    endif
endfunction

function! testscript#OpenReferenceForFirstWord()
	" Strip comment characters
	let line = substitute( getline('.'), '^\s*\/\/\(.\{-}\)', '\1', '' )
	
	let currentLineWords = split(line)
	if len(currentLineWords) > 0 
		let word = currentLineWords[0]
		if word == 'If' || word == 'Else' || word == 'EndIf'
			let word = 'If / Else / EndIf'
		elseif word == 'While' || word == 'EndWhile'
			let word = 'While / EndWhile'
		elseif word == 'IsVariableExist' || word == '@param'
			let word = 'IsVariableExist / @param'
		endif
		call TestReference(word)
	endif
endfunction

" ------------- Open CSV for current TC, or TC for current CSV

function! testscript#SwitchTcAndCsv()
    let ext = expand("%:p:e")
    if ext == "ts"
        let switchfilename = expand("%:t:r") . ".csv"
    elseif ext == "csv"
        let switchfilename = expand("%:t:r") . ".ts"
    endif
    :exec "tab drop " . expand("%:p:h") . "/" . switchfilename
endfunction

" ------------- Open TC
function! PromptForTCNum()
    call inputsave()
    let name = input('Enter TC number: ')
    call inputrestore()
    return name
endfunction

function! OpenTCNum(tcnum)
    :exec "tabf " . g:tsProjectFolder . "/**/*" . a:tcnum . ".ts"
endfunction

function! testscript#PromptOpenTCNum()
    let tcnum = PromptForTCNum()
    call OpenTCNum(tcnum)
endfunction

" ------------- Open Spira page for TC
function! GetCurrentTCNum()
    let fname = expand("%:t")
    let tcnum = matchstr(fname, '\v.*\.TC\zs(\d+)')
    if tcnum == ""
        let tcnum = PromptForTCNum()
    endif
    return tcnum
endfunction

function! OpenSpiraForTC(tcnum)
    exec "silent !cmd /c start " . g:tsSpiraURL . a:tcnum . ".aspx"
endfunction

function! testscript#OpenSpira()
    let tcnum = GetCurrentTCNum()
    call OpenSpiraForTC(tcnum)
endfunction


" ------------- Version Control
function! testscript#CheckoutCurrentFile()
    :silent exec "!\"" . g:tsTfsExePath . "\" checkout \"" . expand("%:p") . "\""
endfunction

function! testscript#CheckinCurrentFile()
    :exec "!\"" . g:tsTfsExePath . "\" checkin \"" . expand("%:p") . "\""
endfunction

function! testscript#AddCurrentFile()
    :exec "!\"" . g:tsTfsExePath . "\" add \"" . expand("%:p") . "\""
endfunction

function! testscript#UpdateWorkspace()
	:exec "!\"" . g:tsTfsExePath . "\" get \"" . g:tsProjectFolder . "\" /recursive"
endfunction
