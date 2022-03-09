function zathura#viewer_command()
    if g:mzview_synctex
        return "zathura -x \"echo %{line} %{input}\" " . g:pdf_file
    else
        return "zathura " . g:pdf_file
    endif
endfunction

function zathura#synctex_forward()
    execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:pdf_file
    redraw!
endfunction
