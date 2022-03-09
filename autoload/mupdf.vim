function mupdf#viewer_command()
    return "mupdf " . g:pdf_file
endfunction

function mupdf#synctex_forward()
    " TODO implement xdotools hack
    return
endfunction
