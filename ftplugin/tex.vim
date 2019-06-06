let g:mzview_autobuild = get(g:, 'mzview_autobuild', 0)

augroup autobuild
    autocmd! * <buffer>
    if g:mzview_autobuild
        autocmd CursorHold,CursorHoldI <buffer> call mzview#rebuild_pdf()
    endif
augroup END

command! SynctexForward call mzview#synctex_forward()
command! -nargs=? -bang SpawnViewer call mzview#spawn_viewer(<args>, <bang>0)
command! UpdateViewer call mzview#update_viewer()

setlocal updatetime=1000

map <localleader>s :SynctexForward<cr>
