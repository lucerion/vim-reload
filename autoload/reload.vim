" ==============================================================
" Description:  Vim plugin that reloads vimrc and plugins
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-reload
" Version:      1.0.0 (2017-01-06)
" Licence:      BSD-3-Clause
" ==============================================================

let s:allowed_files = [
  \ '.*\/after\/.*\.vim$',
  \ '.*\/autoload\/.*\.vim$',
  \ '.*\/colors\/.*\.vim$',
  \ '.*\/compiler\/.*\.vim$',
  \ '.*\/ftdetect\/.*\.vim$',
  \ '.*\/ftplugin\/.*\.vim$',
  \ '.*\/indent\/.*\.vim$',
  \ '.*\/plugin\/.*\.vim$',
  \ '.*\/syntax\/.*\.vim$'
  \ ]

func! reload#vimrc(...) abort
  let l:files = s:vimrc_files(a:000)

  call s:reload_files(l:files)
endfunc

if !exists('s:plugin_is_used')
  func! reload#plugin(...) abort
    let s:plugin_is_used = 1

    let l:dirs = s:plugin_dirs(a:000)
    call s:reload_files_in_dirs(l:dirs)

    unlet s:plugin_is_used
  endfunc
endif

func! s:vimrc_files(files) abort
  if len(a:files)
    return a:files
  endif

  if len(g:reload_vimrc_files)
    return g:reload_vimrc_files
  endif

  return []
endfunc

func! s:plugin_dirs(dirs) abort
  if len(a:dirs)
    return a:dirs
  endif

  if len(g:reload_plugin_dir)
    return g:reload_plugin_dir
  endif

  return []
endfunc

if !exists('s:plugin_is_used')
  func! s:reload_files(files) abort
    let l:full_paths = map(a:files, 'expand(v:val)')
    let l:existing_files = filter(l:full_paths, 'filereadable(v:val)')

    for l:file in l:existing_files
      silent exec 'source' l:file
    endfor
  endfunc
endif

func! s:reload_files_in_dirs(dirs) abort
  let l:plugins_files = s:plugins_files(a:dirs)
  let l:allowed_files = s:allowed_files(l:plugins_files)
  let l:loaded_files = s:loaded_files(l:allowed_files)

  call s:reload_files(l:loaded_files)
endfunc

func! s:plugins_files(dirs) abort
  return split(globpath(join(a:dirs, ','), '*/**'), '\n')
endfunc

func! s:allowed_files(files) abort
  return filter(a:files, 's:is_allowed(v:val)')
endfunc

func! s:loaded_files(files) abort
  let l:lines = ''
  redir => l:lines
  silent scriptnames
  redir END

  let l:files = split(l:lines, '\n')
  let l:filenames = map(l:files, 's:filename(v:val)')
  let l:full_paths = map(l:filenames, 'expand(v:val)')

  return filter(a:files, 'index(l:full_paths, v:val) > 0')
endfunc

func! s:is_allowed(path) abort
  let l:allowed_files = filter(s:allowed_files, 'a:path =~ v:val')

  return len(l:allowed_files)
endfunc

func! s:filename(path) abort
  return expand(matchstr(a:path, '^\s*\d\+:\s\+\zs.\+$'))
endfunc
