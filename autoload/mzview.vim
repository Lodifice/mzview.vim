function mzview#find_pdf()
    let pdf_files = split(globpath(&l:path, "*.pdf"), "\n")
    if len(pdf_files) == 0
        echoerr "There are 0 PDF files in the path, please specify one."
        return
    endif
    let found = -1
    " TODO
    " change to > 1 and switch order of then/else
    " go crazy
    if len(pdf_files) == 1
        let found = 0
    else
        let candidate = substitute(bufname('%'), "\.tex", ".pdf", "")
        for i in range(len(pdf_files))
            if candidate ==# pdf_files[i]
                echom "There are " . len(pdf_files) . " PDF files in the path, guessing " . pdf_files[i] . " based on the name of the current buffer."
                let found = i
                break
            endif
        endfor
        if found < 0
            echoerr "There are " . len(pdf_files) . " PDF files in the path and I can't figure out which one you want, please specify one."
        return
    endif
    return pdf_files[found]
endfunction

function mzview#spawn_viewer(pdf_file, force)
    if exists("g:pdf_viewer")
        if job_info(g:pdf_viewer)["status"] !=# "dead"
            echoerr "Viewer already spawned for " . g:pdf_file . ", close it first."
            return
        endif
    endif
    if exists("g:pdf_file") && !a:force
        echom "Respawning viewer for " . g:pdf_file . ", use SpawnViewer! to override."
    else
        if empty(a:pdf_file)
            let g:pdf_file = mzview#find_pdf()
            if g:pdf_file == "0"
                unlet g:pdf_file
                return
            endif
        else
            let g:pdf_file = a:pdf_file
        endif
    endif
    let viewer_command = zathura#viewer_command()
    let g:pdf_viewer = job_start(viewer_command, {"out_cb": "mzview#synctex_backward"})
    let g:building = 0
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
