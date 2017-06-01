" Vim syntax file
" Language: Absolute Software testscript
" Maintainer: Grayson Bartlet

" Check that syntax wasn't previously defined
if exists("b:current_syntax")
  finish
endif
let b:current_syntax = "testscript"

" NOTE: Lower items have higher priority

" First word of (most) lines are functions
" \zs tells it to start matching, don't need lookbehind
syn match function "^\s*\zs\a\+"
" Keywords
syn keyword basicKeyword If Else EndIf While EndWhile param
" TODOs only valid when contained in another element 
syn keyword todo contained TODO FIXME XXX NOTE
" Comments start with //, can contain todos
syn match comment "//.*$" contains=todo
" Strings. Keepend means end of string also ends all contained regions.
syn region string start='"' skip='\\.' end='"' contains=identifier,xpath keepend
syn region string start="'" skip='\\.' end="'" contains=identifier,xpath keepend
" Strings contain substituted variables
" \@<! is negative lookbehind: don't match a % that's preceded by a \
syn region identifier start="\\\@<!%" skip='\\.' end="%" contained
" Numbas
syn match number '\<\d\+\>'


hi def link basicKeyword Statement
" Don't need to link the todo and Todo groups, they're the same
"hi def link todo Todo
"hi def link comment Comment


" REGEX NOTES: \v at beginning of pattern makes it very magical
" (meaning special chars like () have special meanings)
