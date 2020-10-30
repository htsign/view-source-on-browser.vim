function! s:to_html(...) abort range
    let browser_path = exists('g:vsob#browser_path') ? g:vsob#browser_path : $ProgramFiles .. '\Internet Explorer\iexplore.exe'
    let source_fonts = exists('g:vsob#source_fonts') ? g:vsob#source_fonts : ['Ricty', 'Cica', 'Consolas', 'MeiryoKe', 'YuGothic', 'Meiryo']
    let colorscheme = execute('colorscheme')->trim()
    if a:0 >= 1
        execute('colorscheme ' .. a:1)
    endif

    let number_status = execute('set number?')->trim()
    setlocal nonumber

    execute(printf('%d,%dTOhtml', a:firstline, a:lastline))
    execute(printf('silent /^<style>$/,/<\/style>/s/\%%(monospace\)\@=/%s%s/g', source_fonts->join(', '), len(source_fonts) ? ', ' : ''))

    let filepath = $temp .. '/' .. expand('%:t')
    execute('silent write! ' .. filepath)
    execute(printf('silent !"%s" "%s"', browser_path, filepath))
    bdelete!

    execute('colorscheme ' .. colorscheme)
    execute('setlocal ' .. number_status)
endfunction

command! -nargs=? -complete=color -range=%
    \ ViewOnIE <line1>,<line2>call s:to_html(<f-args>)
