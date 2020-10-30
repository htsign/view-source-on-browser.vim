function! s:to_html(...) abort range
    let l:browser_path = exists('g:vsob#browser_path') ? g:vsob#browser_path : $ProgramFiles .. '\Internet Explorer\iexplore.exe'
    let l:source_fonts = exists('g:vsob#source_fonts') ? g:vsob#source_fonts : ['Ricty', 'Cica', 'Consolas', 'MeiryoKe', 'YuGothic', 'Meiryo']
    let l:colorscheme = execute('colorscheme')->trim()
    if a:0 >= 1
        execute('colorscheme ' .. a:1)
    endif

    let l:number_status = execute('set number?')->trim()
    setlocal nonumber

    execute(printf('%d,%dTOhtml', a:firstline, a:lastline))
    execute(printf('silent /^<style>$/,/<\/style>/s/\%%(monospace\)\@=/%s%s/g', l:source_fonts->join(', '), len(l:source_fonts) ? ', ' : ''))

    let l:filepath = $temp .. '/' .. expand('%:t')
    execute('silent write! ' .. l:filepath)
    execute(printf('silent !"%s" "%s"', l:browser_path, l:filepath))
    bdelete!

    execute('colorscheme ' .. l:colorscheme)
    execute('setlocal ' .. l:number_status)
endfunction


command! -nargs=? -complete=color -range=%
    \ ViewOnIE <line1>,<line2>call <SID>to_html(<f-args>)
