" =============================================================================
" File:          autoload/ctrlp/phpnamespace.vim
" Description:   Example extension for ctrlp.vim
" =============================================================================

" To load this extension into ctrlp, add this to your vimrc:
"
"     let g:ctrlp_extensions = ['phpnamespace']
"
" Where 'phpnamespace' is the name of the file 'phpnamespace.vim'
"
" For multiple extensions:
"
"     let g:ctrlp_extensions = [
"         \ 'my_extension',
"         \ 'my_other_extension',
"         \ ]

" Load guard
if ( exists('g:loaded_ctrlp_phpnamespace') && g:loaded_ctrlp_phpnamespace )
    \ || v:version < 700 || &cp
    finish
endif
let g:loaded_ctrlp_phpnamespace = 1


" Add this extension's settings to g:ctrlp_ext_vars
"
" Required:
"
" + init: the name of the input function including the brackets and any
"         arguments
"
" + accept: the name of the action function (only the name)
"
" + lname & sname: the long and short names to use for the statusline
"
" + type: the matching type
"   - line : match full line
"   - path : match full line like a file or a directory path
"   - tabs : match until first tab character
"   - tabe : match until last tab character
"
" Optional:
"
" + enter: the name of the function to be called before starting ctrlp
"
" + exit: the name of the function to be called after closing ctrlp
"
" + opts: the name of the option handling function called when initialize
"
" + sort: disable sorting (enabled by default when omitted)
"
" + specinput: enable special inputs '..' and '@cd' (disabled by default)
"
call add(g:ctrlp_ext_vars, {
    \ 'init': 'ctrlp#phpnamespace#init()',
    \ 'accept': 'ctrlp#phpnamespace#accept',
    \ 'lname': 'CtrlP php import',
    \ 'sname': 'php-import',
    \ 'type': 'line',
    \ 'enter': 'ctrlp#phpnamespace#enter()',
    \ 'exit': 'ctrlp#phpnamespace#exit()',
    \ 'opts': 'ctrlp#phpnamespace#opts()',
    \ 'sort': 0,
    \ 'specinput': 0,
    \ })



function! ctrlp#phpnamespace#init()
  return s:results
endfunction

function! ctrlp#phpnamespace#results(results)
  let s:results = a:results
endfunction

" The action to perform on the selected string
"
" Arguments:
"  a:mode   the mode that has been chosen by pressing <cr> <c-v> <c-t> or <c-x>
"           the values are 'e', 'v', 't' and 'h', respectively
"  a:str    the selected string
"
function! ctrlp#phpnamespace#accept(mode, str)
    " For this example, just exit ctrlp and run help
    call ctrlp#exit()
    call DoPhpInsertUse(a:str)
endfunction

function! ctrlp#phpnamespace#enter()
endfunction

function! ctrlp#phpnamespace#exit()
endfunction

function! ctrlp#phpnamespace#opts()
endfunction

let s:id = g:ctrlp_builtins + len(g:ctrlp_ext_vars)

function! ctrlp#phpnamespace#id()
    return s:id
endfunction

" vim:nofen:fdl=0:ts=2:sw=2:sts=2
