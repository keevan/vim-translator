" ============================================================================
" FileName: translator.vim
" Author: voldikss <dyzplus@gmail.com>
" GitHub: https://github.com/voldikss
" ============================================================================

scriptencoding utf-8

if exists('g:loaded_translator')
  finish
endif
let g:loaded_translator= 1

let g:translator_target_lang = get(g:, 'translator_target_lang', 'zh')
let g:translator_source_lang = get(g:, 'translator_source_lang', 'auto')
let g:translator_proxy_url = get(g:, 'translator_proxy_url', v:null)
let g:translator_history_enable = get(g:, 'translator_history_enable', v:false)
let g:translator_window_max_width = get(g:, 'translator_window_max_width', v:null)
let g:translator_window_max_height = get(g:, 'translator_window_max_height', v:null)
let g:translator_window_borderchars = get(g:, 'translator_window_borderchars', ['─', '│', '─', '│', '┌', '┐', '┘', '└'])
let g:translator_window_enable_icon = get(g:, 'translator_window_enable_icon', v:true)
let g:translator_debug_mode = get(g:, 'translator_debug_mode', v:false)
let g:translator_translate_shell_options = get(g:, 'translator_translate_shell_options', [])

" For old variables
function! s:transfer(var1, var2) abort
  if exists(a:var2)
    execute 'let '. a:var1 . '=' . a:var2
  endif
endfunction

call s:transfer('g:translator_target_lang', 'g:vtm_target_lang')
call s:transfer('g:translator_proxy_url', 'g:vtm_proxy_url')
call s:transfer('g:translator_history_enable', 'g:vtm_history_enable')
call s:transfer('g:translator_window_max_width', 'g:vtm_popup_max_width')
call s:transfer('g:translator_window_max_height', 'g:vtm_popup_max_height')
call s:transfer('g:translator_default_mappings', 'g:vtm_default_mapping')

if match(g:translator_target_lang, 'zh') >= 0
  let g:translator_default_engines = get(g:, 'translator_default_engines', ['ciba', 'youdao'])
else
  let g:translator_default_engines = get(g:, 'translator_default_engines', ['google', 'bing'])
endif

nnoremap <silent> <Plug>Translate   :call translator#translate('echo', v:false, '-t ' . expand('<cword>'), '')<CR>
vnoremap <silent> <Plug>TranslateV  :<C-U>call translator#translate('echo', v:true, '', '')<CR>
nnoremap <silent> <Plug>TranslateW  :call translator#translate('window', v:false, '-t ' . expand('<cword>'), '')<CR>
vnoremap <silent> <Plug>TranslateWV :<C-U>call translator#translate('window', v:true, '', '')<CR>
nnoremap <silent> <Plug>TranslateR  viw:<C-U>call translator#translate('replace', v:false, '', '')<CR>
vnoremap <silent> <Plug>TranslateRV :<C-U>call translator#translate('replace', v:true, '', '')<CR>
nnoremap <silent> <Plug>TranslateH  :call translator#history#export()

if !exists(':Translate')
  command! -complete=customlist,translator#cmdline#complete -nargs=* -bang -range
    \ Translate
    \ call translator#translate('echo', v:false, <q-args>, '<bang>', <line1>, <line2>, <count>)
endif

if !exists(':TranslateW')
  command! -complete=customlist,translator#cmdline#complete -nargs=* -bang -range
    \ TranslateW
    \ call translator#translate('window', v:false, <q-args>, '<bang>', <line1>, <line2>, <count>)
endif

if !exists(':TranslateR')
  command! -complete=customlist,translator#cmdline#complete -nargs=* -bang -range
    \ TranslateR
    \ exec 'normal viw<Esc>' |
    \ call translator#translate('replace', v:false, <q-args>, '<bang>', <line1>, <line2>, <count>)
endif

if !exists(':TranslateH')
  command! -nargs=0   TranslateH call translator#history#export()
endif

if !exists(':TranslateL')
  command! -nargs=0   TranslateL call translator#debug#open_log()
endif
