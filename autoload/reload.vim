func! reload#vimrc(...)
  let l:files = []

  if len(a:000)
    let l:files = a:000
  else
    if len(g:vim_reload_vimrc)
      let l:files = g:vim_reload_vimrc
    endif
  endif

  call s:reload_files(l:files)
endfunc

if !exists('s:plugin_is_used')
  func! reload#plugin(...)
    let s:plugin_is_used = 1

    let l:dirs = []

    if len(a:000)
      let l:dirs = a:000
    else
      if len(g:vim_reload_plugin)
        let l:dirs = g:vim_reload_plugin
      endif
    endif

    let l:plugins_files = split(globpath(join(l:dirs, ','), '*/**'), '\n')
    let l:allowed_files = filter(l:plugins_files, 's:is_allowed(v:val)')
    let l:loaded_files = s:loaded_files()
    let l:files = filter(l:allowed_files, 'index(l:loaded_files, v:val) > 0')

    call s:reload_files(l:files)

    unlet s:plugin_is_used
  endfunc
endif

if !exists('s:plugin_is_used')
  func! s:reload_files(files)
    for l:file in filter(s:full_paths(a:files), 'filereadable(v:val)')
      exec 'source' l:file
    endfor
  endfunc
endif

func! s:full_paths(files)
  return map(a:files, 'expand(v:val)')
endfunc

func! s:is_allowed(path)
  let l:is_allowed = 0

  for l:pattern in g:vim_reload_plugin_allowed_files
    if a:path =~ l:pattern
      let l:is_allowed = 1
    endif
  endfor

  return l:is_allowed
endfunc

func! s:loaded_files()
  let l:lines = ''
  redir => l:lines
  silent scriptnames
  redir END

  let l:filenames = map(split(l:lines, '\n'), 's:loaded_filename(v:val)')

  return s:full_paths(l:filenames)
endfunc

func! s:loaded_filename(value)
  return expand(matchstr(a:value, '^\s*\d\+:\s\+\zs.\+$'))
endfunc
