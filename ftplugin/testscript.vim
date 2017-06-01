" This script is run whenever a file matching the testscript filetype is
" opened (that's determined by the ftdetect/ file).
" It's used to set settings and shortcuts just for .ts files.
" Most actual functionality is loaded on demand by autoload/testscript.vim


" ---------------- Assign shortcuts
" User can set g:auto_map_testscript_keys to 0 to use their own mappings
if !exists('g:auto_map_testscript_keys')
    let g:auto_map_testscript_keys = 1
endif

if g:auto_map_testscript_keys
    nnoremap <buffer> <leader>ot :call testscript#OpenTs()<CR>
    nnoremap <buffer> <leader>oc :call testscript#OpenCsv()<CR>
    nnoremap <buffer> <silent> <leader>r :call testscript#OpenReferenceForFirstWord()<CR>
    nnoremap <buffer> <silent> <leader>fv :call testscript#FindVariable()<CR>
endif

"Create menu items
let leader = escape( exists('g:mapleader') ? g:mapleader : '\', '\' )
exec "anoremenu <silent> TestScript.Current\\ Line.Open\\ Testscript<Tab>".leader."ot :call testscript#OpenTs()<CR>"
exec "anoremenu <silent> TestScript.Current\\ Line.Open\\ Csv<Tab>".leader."oc :call testscript#OpenCsv()<CR>"
exec "anoremenu <silent> TestScript.Current\\ Line.Open\\ Reference<Tab>".leader."r :call testscript#OpenReferenceForFirstWord()<CR>"
exec "anoremenu <silent> TestScript.Current\\ Line.Find\\ Variable<Tab>".leader."fv :call testscript#FindVariable()<CR>"

"Create tooltips for menu items
tmenu TestScript.Current\ Line.Open\ Testscript If the current line has an ExecuteScript statement, opens the script being executed.
tmenu TestScript.Current\ Line.Open\ Csv If the current line has an ExecuteScript statement with a csv argument, opens the csv being used.
tmenu TestScript.Current\ Line.Open\ Reference Opens the QAPlayer syntax reference for the statement on the current line.
tmenu TestScript.Current\ Line.Find\ Variable Finds the definition of the variable under the cursor.

" ---------------- misc options
setlocal noexpandtab
"Set indenting keywords
setlocal smartindent cinwords=If,While,Else
setlocal commentstring=//%s
"If file is TC... 
if (match( expand("%:t:r"),"TC" )) != -1
    setlocal ballooneval
    setlocal balloonexpr=BalloonExpr()
endif

" --------------- display csv variable values when you hover over them

function! BalloonExpr()
    if match(v:beval_text, "^DC") != -1
        let csvfile = expand("%:p:r") . ".csv"
        if filereadable(csvfile)
            return GetCsvValue(csvfile, v:beval_text)
        endif
    endif
    return ""
endfunction


" ------------ Get value from csv

function! GetCsvValue(csvfile, variable)
    let lines = readfile(a:csvfile, 2) "Assume first line is variables, second is values.
    let varline = matchstr(lines[0], "^.*,".a:variable."\\>") "gives line up until desired variable
    let colnum = len( split(varline, ",") ) - 1 "number of preceding commas
    "TODO: don't match escaped commas
    return a:variable . " = " . matchstr(lines[1],"\\v([^,]+,){".colnum."}\\zs[^,]+")
endfunction 
