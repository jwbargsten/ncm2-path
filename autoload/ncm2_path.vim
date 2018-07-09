if get(s:, 'loaded', 0)
    finish
endif
let s:loaded = 1

let g:ncm2_path#proc = yarp#py3('ncm2_path')

let g:ncm2_path#bufpath_source = get(g:, 'ncm2_path#bufpath_source', {
            \ 'name': 'bufpath',
            \ 'priority': 6,
            \ 'mark': '/',
            \ 'word_pattern': '([^\W]|[-.~%$])+',
            \ 'complete_pattern': [
            \       '(\.[/\\]+|[a-zA-Z]:\\+|~\/+)',
            \       '([^\W]|[-.~%$]|[/\\])+[/\\]+'],
            \ 'on_complete': 'ncm2_path#on_complete_bufpath',
            \ 'on_warmup': 'ncm2_path#on_warmup',
            \ })

let g:ncm2_path#bufpath_source = extend(g:ncm2_path#bufpath_source,
            \ get(g:, 'ncm2_path#bufpath_source_override', {}),
            \ 'force')

let g:ncm2_path#cwdpath_source = get(g:, 'ncm2_path#cwdpath_source', {
            \ 'name': 'cwdpath',
            \ 'priority': 5,
            \ 'mark': '/',
            \ 'word_pattern': '([^\W]|[-.~%$])+',
            \ 'complete_pattern': [
            \       '(\.[/\\]+|[a-zA-Z]:\\+|~\/+)',
            \       '([^\W]|[-.~%$]|[/\\])+[/\\]+'],
            \ 'on_complete': 'ncm2_path#on_complete_cwdpath',
            \ 'on_warmup': 'ncm2_path#on_warmup',
            \ })

let g:ncm2_path#cwdpath_source = extend(g:ncm2_path#cwdpath_source,
            \ get(g:, 'ncm2_path#cwdpath_source_override', {}),
            \ 'force')

let g:ncm2_path#rootpath_source = get(g:, 'ncm2_path#rootpath_source', {
            \ 'name': 'rootpath',
            \ 'priority': 5,
            \ 'mark': '/',
            \ 'word_pattern': '([^\W]|[-.~%$])+',
            \ 'complete_pattern': [
            \       '(\.[/\\]+|[a-zA-Z]:\\+|~\/+)',
            \       '([^\W]|[-.~%$]|[/\\])+[/\\]+'],
            \ 'on_complete': 'ncm2_path#on_complete_rootpath',
            \ 'on_warmup': 'ncm2_path#on_warmup',
            \ })

let g:ncm2_path#rootpath_source = extend(g:ncm2_path#rootpath_source,
            \ get(g:, 'ncm2_path#rootpath_source_override', {}),
            \ 'force')

let g:ncm2_path#path_pattern = get(g:
            \ , 'ncm2_path#path_pattern', '(([^\W]|[-.~%$]|[/\\])+)')

func! ncm2_path#init()
    call ncm2#register_source(g:ncm2_path#bufpath_source)
    call ncm2#register_source(g:ncm2_path#cwdpath_source)
    call ncm2#register_source(g:ncm2_path#rootpath_source)
endfunc

func! ncm2_path#on_warmup(ctx)
    call g:ncm2_path#proc.jobstart()
endfunc

func! ncm2_path#on_complete_bufpath(ctx)
    if empty(a:ctx.filepath)
        return
    endif
    call g:ncm2_path#proc.try_notify('on_complete_bufpath', a:ctx, g:ncm2_path#path_pattern)
endfunc

func! ncm2_path#on_complete_cwdpath(ctx)
    call g:ncm2_path#proc.try_notify('on_complete_cwdpath', a:ctx, g:ncm2_path#path_pattern, getcwd())
endfunc

func! ncm2_path#on_complete_rootpath(ctx)
    call g:ncm2_path#proc.try_notify('on_complete_rootpath', a:ctx, g:ncm2_path#path_pattern)
endfunc

