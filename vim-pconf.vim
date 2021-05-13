if exists("g:loaded_vim_pconf") || &cp
    finish
endif
let g:loaded_vim_pconf = '1.0'

let g:pconf = '.vimrc.local'
let g:pconf_db = expand('<sfile>:p:h') . '/pconfdb'

let s:pconf_dict = {}

function s:loadPconfDict()
    if !filereadable(g:pconf_db)
        return
    endif

    " Read db in list form
    let pcrl = readfile(g:pconf_db)

    " Convert db to a dictionary
    while !empty(pcrl)
        let [k, v; t] = pcrl
        let pcrl = t
        let s:pconf_dict[k] = v
    endwhile
endfunction

function s:loadPconf()
    if !filereadable(expand('%:p:h') . '/' . g:pconf)
        return
    endif

    " Get hash of pconf file
    let hash = get(s:pconf_dict, getcwd(), '')

    if !hash
        call <SID>unregisteredAction()
    else
        if split(system('md5sum', g:pconf))[0] == hash
            execute 'source' g:pconf
        else
            echom 'pconf hash mismatch! Refused to load!'
        endif
    endif
endfunction

function s:unregisteredAction()
    if input('pconf is unregistered. Register? y/n ') == 'y'
        echom 'registering'
        call <SID>registerPconf()
        call <SID>loadPconf()
    endif
endfunction

function s:registerPconf()
    if !filereadable(expand('%:p:h') . '/' . g:pconf)
        return
    endif
    
    " Add pconf hash to db dictionary
    let s:pconf_dict[getcwd()] = split(system('md5sum', g:pconf))[0]

    " Write complete db dictionary back to db file
    let pcrl = []
    for [k, v] in items(s:pconf_dict)
        let pcrl += [k, v]
    endfor
    call writefile(pcrl, g:pconf_db)
endfunction

" Load pconf DB from file and attempt to load
" a pconf file if found
augroup vim_pconf
    autocmd!
    autocmd VimEnter * call <SID>loadPconfDict()
    autocmd VimEnter * call <SID>loadPconf()
augroup end

" User command to register a new pconf file
command RegisterPconf call <SID>registerPconf()

