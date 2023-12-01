function sioyek#viewer_command()
    if g:mzview_synctex
        return "sioyek --new-window --inverse-search \"echo %2 %1\" " . g:pdf_file
    else
        return "sioyek " . g:pdf_file
    endif
endfunction

function sioyek#synctex_forward()
    execute "silent! !sioyek --forward-search-file " . bufname('%') " --forward-search-line " . line('.') . " " . g:pdf_file
    redraw!
endfunction
