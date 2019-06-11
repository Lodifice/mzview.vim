let g:mzview_autobuild = get(g:, 'mzview_autobuild', 0)
let g:mzview_buildonwrite = get(g:, 'mzview_buildonwrite', 0)
let g:mzview_pdfrefresh = get(g:, 'mzview_pdfrefresh', 0)

augroup autobuild
    autocmd! * <buffer>
    if g:mzview_autobuild
        autocmd CursorHold,CursorHoldI <buffer> call mzview#rebuild_pdf(0)
    endif
augroup END

augroup buildonwrite
    autocmd! * <buffer>
    if g:mzview_buildonwrite
        autocmd BufWrite <buffer> call mzview#rebuild_pdf(0)
    endif
augroup END

command! SynctexForward call mzview#synctex_forward()
command! -nargs=? -bang SpawnViewer call mzview#spawn_viewer(<args>, <bang>0)
command! RebuildPDF call mzview#rebuild_pdf(1)
command! UpdateViewer call mzview#update_viewer()

setlocal updatetime=1000

map <localleader>s :SynctexForward<cr>
