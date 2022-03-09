let g:mzview_autobuild = get(g:, 'mzview_autobuild', 0)
let g:mzview_buildonwrite = get(g:, 'mzview_buildonwrite', 0)
let g:mzview_pdfrefresh = get(g:, 'mzview_pdfrefresh', 0)
let g:mzview_synctex = get(g:, 'mzview_synctex', 1)

" TODO make this more sophisticated, i.e. search for Makefile, if not found,
" try latexmk, etc.
" TODO support using the internal :make and makeprg
let g:mzview_buildcmd = get(g:, 'mzview_buildcmd', '"latexmk -pdf -synctex=1 " . substitute(g:pdf_file, "\.pdf", ".tex", "")')

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

noremap <Plug>mzview_SynctexForward :SynctexForward<cr>
noremap <Plug>mzview_RebuildPDF :RebuildPDF<cr>
noremap <Plug>mzview_UpdateViewer :UpdateViewer<cr>
