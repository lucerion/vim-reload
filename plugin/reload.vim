" ==============================================================
" Description:  Vim plugin that reloads vimrc and plugins
" Author:       Alexander Skachko <alexander.skachko@gmail.com>
" Homepage:     https://github.com/lucerion/vim-reload
" Version:      1.0.0 (2017-01-06)
" Licence:      BSD-3-Clause
" ==============================================================

if exists('g:loaded_reload') || &compatible || v:version < 700
  finish
endif
let g:loaded_reload = 1

if !exists('g:reload_vimrc')
  let g:reload_vimrc = [$MYVIMRC]
endif

if !exists('g:reload_plugin')
  let g:reload_plugin = ['~/.vim']
endif

if !exists('g:reload_vimrc_autoreload')
  let g:reload_vimrc_autoreload = 0
endif

if g:reload_vimrc_autoreload
  augroup VimrcAutoreload
    autocmd!
    autocmd BufWritePost * call reload#vimrc()
  augroup END
endif

if !exists('g:reload_plugin_autoreload')
  let g:reload_plugin_autoreload = 0
endif

if g:reload_plugin_autoreload
  augroup PluginAutoreload
    autocmd!
    autocmd BufWritePost * call reload#plugin()
  augroup END
endif

if !exists('g:reload_plugin_allowed_files')
  let g:reload_plugin_allowed_files = [
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
endif

comm! -nargs=* -complete=file ReloadVimrc call reload#vimrc(<f-args>)
comm! -nargs=* -complete=dir ReloadPlugin call reload#plugin(<f-args>)
