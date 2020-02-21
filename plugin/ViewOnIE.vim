function! s:to_html(...) range
    let colorscheme = execute('colorscheme')->trim()
    if a:0 >= 1
        execute('colorscheme ' .. a:1)
    endif

    let number_status = execute('set number?')->trim()
    setlocal nonumber

    let fonts = exists('g:vsob#source_fonts')
        \ ? g:vsob#source_fonts
        \ : ['Ricty', 'Cica', 'Consolas', 'MeiryoKe', 'YuGothic', 'Meiryo']
    execute(printf('%d,%dTOhtml', a:firstline, a:lastline))
    execute('silent /^<style>$/,/<\/style>/s/\%(monospace\)\@=/' .. fonts->join(', ') .. ', /g')

    let filepath = $temp .. '/' .. expand('%:t')
    execute('silent write! ' .. filepath)

    let browser = exists('g:vsob#browser_path')
        \ ? g:vsob#browser_path
        \ : $ProgramFiles .. '\Internet Explorer\iexplore.exe'
    execute(printf('silent !"%s" "%s"', browser, filepath))
    bdelete!

    execute('colorscheme ' .. colorscheme)
    execute('setlocal ' .. number_status)
endfunction

command! -nargs=? -complete=color -range=%
    \ ViewOnIE <line1>,<line2>call s:to_html(<f-args>)
