function mzview#find_pdf()
    let pdf_files = split(globpath(&l:path, "*.pdf"), "\n")
    if len(pdf_files) != 1
        echoerr "There are " . len(pdf_files) . " PDF files in the path."
        return
    endif
    return pdf_files[0]
endfunction

function mzview#spawn_viewer(pdf_file, force)
    if !exists("g:pdf_viewer") || a:force
        if empty(a:pdf_file)
            let g:pdf_file = mzview#find_pdf()
        else
            let g:pdf_file = a:pdf_file
        endif
        let viewer_command = zathura#viewer_command()
        let g:pdf_viewer = job_start(viewer_command, {"out_cb": "mzview#synctex_backward"})
        let g:building = 0
    endif
endfunction

function mzview#update_viewer()
    if exists("g:pdf_viewer") && g:mzview_pdfrefresh
        call job_stop(g:pdf_viewer, "hup")
    endif
endfunction

function mzview#rebuild_pdf(always)
    if !exists("g:building") || g:building || (!a:always && !&modified)
        return
    endif
    let g:building = 1
    execute "update"
    call job_start(eval(g:mzview_buildcmd), {"exit_cb": "mzview#handle_rebuild", "in_io": "null", "out_io": "null", "err_io": "null"})
endfunction

function mzview#handle_rebuild(job, status)
    let g:building = 0
    call mzview#update_viewer()
endfunction

function mzview#synctex_forward()
    execute "silent !zathura --synctex-forward " . line('.') . ":" . col('.') . ":" . bufname('%') . " " . g:pdf_file
    redraw!
endfunction

function mzview#synctex_backward(channel, msg)
    let [tex_line; tex_file] = split(a:msg)
    execute "find " . join(tex_file)
    execute "normal " . tex_line . "gg"
endfunction
