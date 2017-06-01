
if !exists('g:auto_map_testscript_keys')
    let g:auto_map_testscript_keys = 1
endif

if g:auto_map_testscript_keys
    nnoremap <buffer> <leader>pl :call ParseLog()<CR>
    nnoremap <buffer> <silent> <2-LeftMouse> :call DoubleClick()<CR>
endif

"Set the search register to --Error, so you can press n to jump to it
let @/="--Error"

" ---------- AUTO-REFRESHING LOG FILE

" This option makes vim re-read the file as it's changed externally
setlocal autoread
" Update every 2 seconds
setlocal updatetime=2000
au! CursorHold QAPlayerLog.txt call Update()
function! Update()
    "CursorHold is called once no key's been pressed for updatetime.
    "We need to press a key to re-trigger it.
    call feedkeys("f\e")
    checktime
endfunction
" This gets triggered by checktime and scrolls to the bottom
au FileChangedShellPost QAPlayerLog.txt normal! G

" ---------- DOUBLE-CLICKING FILEPATHS

" Function called when user double-clicks. If they're clicking a filepath,
" jump to that file.
function! DoubleClick()
    let syntux = testscript#CurrentSyntax()
    if syntux == "filepath"
        let path = expand("<cWORD>")
        if filereadable(path)
            :silent exec "tab drop " . path  
        else
            echo "Unable to locate " . path
        endif
    else
        " If not on filepath, do regular double-click behavior
        :silent exec "normal! viw\<C-g>"
    endif
endfunction

" ---------- PARSING LOG FILES 

if !exists("*ParseLog")
    function! ParseLog()
        let oldreg=@a
        let @a=""
        :silent g/--Error/exec ".-10,.+10 y A| let @A='---------------------------------------------------\n\n\n'"
        let fname = expand("%:r")."-Summary.txt"
        :silent exec "tabe ".fname 
        :normal! ggdG
        :put a
        :silent w
        let @a=oldreg
    endfunction
endif
