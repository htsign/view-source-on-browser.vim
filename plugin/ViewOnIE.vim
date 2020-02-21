let g:vsob#browser_path = $ProgramFiles .. '\Internet Explorer\iexplore.exe'
let g:vsob#source_fonts = ['Ricty', 'Cica', 'Consolas', 'MeiryoKe', 'YuGothic', 'Meiryo']

function! s:to_html(...) abort range
    let colorscheme = execute('colorscheme')->trim()
    if a:0 >= 1
        execute('colorscheme ' .. a:1)
    endif

    let number_status = execute('set number?')->trim()
    setlocal nonumber

    execute(printf('%d,%dTOhtml', a:firstline, a:lastline))

    let fonts = g:vsob#source_fonts
    execute(printf('silent /^<style>$/,/<\/style>/s/\%%(monospace\)\@=/%s%s/g', fonts->join(', '), len(fonts) ? ', ' : ''))

    let filepath = $temp .. '/' .. expand('%:t')
    execute('silent write! ' .. filepath)
    execute(printf('silent !"%s" "%s"', g:vsob#browser_path, filepath))
    bdelete!

    execute('colorscheme ' .. colorscheme)
    execute('setlocal ' .. number_status)
endfunction

command! -nargs=? -complete=color -range=%
    \ ViewOnIE <line1>,<line2>call s:to_html(<f-args>)
