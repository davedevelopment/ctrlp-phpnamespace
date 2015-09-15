
let s:capture = 0

function! PhpFindMatchingUse(clazz)

    " matches use Foo\Bar as <class>
    let pattern = '\%(^\|\r\|\n\)\s*use\_s\+\_[^;]\{-}\_s*\(\_[^;,]*\)\_s\+as\_s\+' . a:clazz . '\_s*[;,]'
    let fqcn = s:searchCapture(pattern, 1)
    if fqcn isnot 0
        return fqcn
    endif

    " matches use Foo\<class>
    let pattern = '\%(^\|\r\|\n\)\s*use\_s\+\_[^;]\{-}\_s*\(\_[^;,]*\%(\\\|\_s\)' . a:clazz . '\)\_s*[;,]'
    let fqcn = s:searchCapture(pattern, 1)
    if fqcn isnot 0
        return fqcn
    endif

endfunction

function! PhpFindFqcnAndInsert(clazz)
    let restorepos = line(".") . "normal!" . virtcol(".") . "|"
    let loadedCount = 0
    let tags = []
    try
        let tags = taglist("^".a:clazz."$")

        if len(tags) < 1
            exe "normal! `z"
            throw "No tag were found for class ".a:clazz."; is your tag file up to date? Tag files in use: ".join(tagfiles(),',')
        endif

        let results = []
        for tag in tags
          let result = tag.name
          if tag.namespace != ""
            let result = tag.namespace.'\'.tag.name
          endif
          let results = results + [result]
        endfor

        if len(results) == 1
            call DoPhpInsertUse(results[0])
            return
        endif

        " if we have more than one result, invoke ctrlp
        call ctrlp#phpnamespace#results(results)
        call ctrlp#init(ctrlp#phpnamespace#id())
    endtry
endfunction

function! PhpInsertUse()
    exe "normal mz"
    " move to the first component
    " Foo\Bar => move to the F
    call search('[[:alnum:]\\_]\+', 'bcW')
    let cur_class = expand("<cword>")
    try
        let fqcn = PhpFindMatchingUse(cur_class)
        if fqcn isnot 0
            exe "normal! `z"
            echo "import for " . cur_class . " already exists"
            return
        endif
        call PhpFindFqcnAndInsert(cur_class)
    endtry

endfunction

function! DoPhpInsertUse(fqcn)
    try
        if a:fqcn is 0
            echo "fully qualified class name was not found"
            return
        endif
        let use = "use ".a:fqcn.";"
        " insert after last use or namespace or <?php
        if search('^use\_s\_[[:alnum:][:blank:]\\_]*;', 'be') > 0
            call append(line('.'), use)
        elseif search('^\s*namespace\_s\_[[:alnum:][:blank:]\\_]*[;{]', 'be') > 0
            call append(line('.'), "")
            call append(line('.')+1, use)
        elseif search('<?\%(php\)\?', 'be') > 0
            call append(line('.'), "")
            call append(line('.')+1, use)
        else
            call append(1, use)
        endif
    catch /.*/
        echoerr v:exception
    finally
        exe "normal! `z"

        " Because the ctrlp is async, we need this to jump back to insert
        if g:backToInsert
            let g:backToInsert = 0
            call feedkeys('a', 'n')
        endif
    endtry
endfunction

function! s:searchCapture(pattern, nr)
    let s:capture = 0
    let str = join(getline(0, line('$')),"\n")
    call substitute(str, a:pattern, '\=[submatch(0), s:saveCapture(submatch('.a:nr.'))][0]', 'e')
    return s:capture
endfunction

function! s:saveCapture(capture)
    let s:capture = a:capture
endfunction
