function! s:to_html(...)
    let colorscheme = execute('colorscheme')->trim()
    if a:0 >= 1
        execute('colorscheme ' .. a:1)
    endif

    let number_status = execute('set number?')->trim()
    setlocal nonumber

    %TOhtml
    silent %s/\%(monospace\)\@=/Consolas, Meiryo, /g

    let filepath = $temp .. '/' .. expand('%:t')
    execute('silent write! ' .. filepath)

    let browser = exists('g:vsob#browser_path')
        \ ? g:vsob#browser_path
        \ : $ProgramFiles .. '\Internet Explorer\iexplore.exe'
    execute('silent !"' .. browser .. '" "' .. filepath .. '"')
    bdelete!

    execute('colorscheme ' .. colorscheme)
    execute('setlocal ' .. number_status)
endfunction

command! -nargs=? ViewOnIE call s:to_html(<f-args>)
