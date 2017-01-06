if exists('g:loaded_vim_reload') || &compatible || v:version < 700
  finish
endif

if !exists('g:vim_reload_vimrc')
  let g:vim_reload_vimrc = [$MYVIMRC]
endif

if !exists('g:vim_reload_plugin')
  let g:vim_reload_plugin = ['~/.vim']
endif

if !exists('g:vim_reload_plugin_allowed_files')
  let g:vim_reload_plugin_allowed_files = [
    \ '.*\/after\/.*\.vim$',
    \ '.*\/autoload\/.*\.vim$',
    \ '.*\/colors\/.*\.vim$',
    \ '.*\/compiler\/.*\.vim$',
    \ '.*\/ftdetect\/.*\.vim$',
    \ '.*\/ftplugin\/.*\.vim$',
    \ '.*\/indent\/.*\.vim$',
    \ '.*\/plugin\/.*\.vim$',
    \ '.*\/syntax\/.*\.vim$',
    \ ]
endif

if !exists('g:vim_reload_vimrc_autoreload')
  let g:vim_reload_vimrc_autoreload = 0
endif

if g:vim_reload_vimrc_autoreload
  augroup vim_reload_vimrc_autoreload
    autocmd!
    autocmd BufWritePost * call reload#vimrc()
  augroup END
endif

if !exists('g:vim_reload_plugin_autoreload')
  let g:vim_reload_plugin_autoreload = 0
endif

if g:vim_reload_plugin_autoreload
  augroup vim_reload_plugin_autoreload
    autocmd!
    autocmd BufWritePost * call reload#plugin()
  augroup END
endif

comm! -nargs=* -complete=file ReloadVimrc call reload#vimrc(<f-args>)
comm! -nargs=* -complete=dir ReloadPlugin call reload#plugin(<f-args>)

let g:loaded_vim_reload = 1
