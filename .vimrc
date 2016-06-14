" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

if !empty($VIMFILES_DIR)
    let vimfiles_dir=expand("$VIMFILES_DIR/")
else
    if has('win32')
        language messages en
        let vimfiles_dir=expand("$HOME/vimfiles/")
    else
        language messages en_US.UTF-8
        let vimfiles_dir=expand("$HOME/.vim/")
    endif
endif

" from http://stevelosh.com/blog/2010/09/coming-home-to-vim/

filetype off
if filereadable(vimfiles_dir."autoload/pathogen.vim")
    call pathogen#helptags()
    call pathogen#infect('bundle/{}')
endif
filetype plugin indent on

" bit prevents some security exploits
"set modelines=0
set modeline
set modelines=3

set ttyfast
set gdefault

set formatoptions=croql
set cinoptions=l1,g0,p0,t0,c0,(s,U1,m1

" save all at focus lost
au FocusLost * :wa

" end stevelosh

set history=250     " keep 250 lines of command line history
set ruler           " show the cursor position all the time

" Don't use Ex mode, use Q for formatting
map Q gq

set number
"set relativenumber

if has('win32') || has('gui') || $TERM == 'xterm' || $TERM == 'screen-256color'
    set t_Co=256    " использовать больше цветов в терминале
endif
if &t_Co > 2
    syntax enable
    set hlsearch
endif

if !(has('gui') || has('win32'))
    if filereadable(vimfiles_dir.'bundle/robokai/colors/robokai.vim')
        colorscheme robokai
        highlight Normal  ctermfg=gray   ctermbg=black guifg=#c0c0c0 guibg=#000040
        if &term == "xterm"
            highlight StatusLine ctermfg=black ctermbg=white term=bold
        else
            highlight StatusLine ctermfg=black term=bold
        endif
        " from darkblue
        highlight Visual	guifg=#8080ff guibg=fg		gui=reverse				ctermfg=lightblue ctermbg=fg cterm=reverse
        highlight VisualNOS	guifg=#8080ff guibg=fg		gui=reverse,underline	ctermfg=lightblue ctermbg=fg cterm=reverse,underline
        " for diff-mode
        highlight DiffChange term=bold cterm=bold ctermfg=black ctermbg=red guibg=DarkMagenta
        "
        highlight Class ctermfg=DarkYellow
        highlight LocalVariable ctermfg=DarkGrey
    endif
    if filereadable(vimfiles_dir.'bundle/vim-bandit/colors/bandit.vim')
        colorscheme bandit
        highlight MatchParen ctermbg=green
        highlight Class ctermfg=DarkYellow
    endif
elseif has('gui') && filereadable(vimfiles_dir.'bundle/twilight/colors/twilight.vim')
    if has("eval")
      let python_highlight_all = 1
      let python_slow_sync = 1
    endif
    colorscheme twilight
elseif has('gui') && filereadable(vimfiles_dir.'bundle/darkz/colors/darkz.vim')
    colorscheme darkz
elseif has('gui') && filereadable(vimfiles_dir.'bundle/lucius/colors/lucius.vim')
    colorscheme lucius
elseif filereadable(expand("$VIMRUNTIME/colors/darkblue.vim"))
    colorscheme darkblue
    " немного "доведем до ума" схему
    if has('gui')
        highlight StatusLine ctermfg=black ctermbg=blue term=bold guifg=darkblue guibg=darkgrey gui=bold
    else
        if !has('win32')
            if &term == "xterm"
                highlight StatusLine ctermfg=blue term=bold
            else
                highlight StatusLine ctermfg=black term=bold
            endif
        endif
        highlight Comment term=bold ctermfg=3 gui=italic guifg=gray50
    endif
    highlight lCursor ctermfg=yellow ctermbg=red   guifg=NONE    guibg=cyan
endif

" Показываем табы в начале строки точками
"set listchars=tab:··i
"set listchars=tab:»\ ,trail:·,eol:¶
"set list

" change rus-las with Ctrl-^
if filereadable(expand("$VIMRUNTIME/keymap/russian-jcukenwin.vim"))
    set keymap=russian-jcukenwin
endif
"setlocal spell spelllang=ru_yo,en_us
" циклическое переключение спелл-чекера (взято с www.opennet.ru/base/X/vim_orfo.txt.html)
if version >= 700 && has("spell")
"   По умолчанию проверка орфографии выключена.
    setlocal spell spelllang=
    setlocal nospell
    "
    function! ChangeSpellLang()
        if &spelllang =~ "en_us"
            setlocal spell spelllang=ru
            echo "spelllang: ru"
        elseif &spelllang =~ "ru"
            setlocal spell spelllang=
            setlocal nospell
            echo "spelllang: off"
        else
            setlocal spell spelllang=en_us
            echo "spelllang: en"
        endif
    endfunc

    " map spell on/off for English/Russian
    map <F11> <Esc>:call ChangeSpiellLang()<CR>
    " limit it to just the top 10 items
    set sps=best,10
endif
" по умолчанию латинская раскладка
set iminsert=0
" по умолчанию поиск латиницей
set imsearch=0
set tabstop=4
set shiftwidth=4
set autoindent  " Copy indent from current line when starting a new line
set smartindent " Do smart autoindenting when starting a new line
set copyindent  " Copy the structure of the existing lines indent
set expandtab "set smarttab
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" new window on right side for vsplit
set splitright
" new window below for split
set splitbelow

" граница переноса
set wrapmargin=5
" подсветим 85ю колонку
if version >= 703
    set colorcolumn=85
endif
" автоматический перенос после 128 колонки
set textwidth=128
" сколько строк повторять при скроллинге
set scrolloff=4
" подсветка строки и колонки курсора
if version >= 700
    set cursorline
endif
"set cursorcolumn
set visualbell " Use visual bell instead of beeping
set noerrorbells " No bell for error messages
" миннимальная высота окна
set winminheight=1
" делать активное окон максимального размера
set noequalalways
set winheight=999

set incsearch        " do incremental searching
set ignorecase
set smartcase

" http://dimio-blog.livejournal.com/16376.html

set hidden          " не выгружать буфер когда переключаешься на другой
if has("mouse")
    if !has("gui_running")
        set mouse=a     " включает поддержку мыши при работе в терминале (без GUI)
    endif
    set mousehide       " скрывать мышь в режиме ввода текста
endif
set showcmd         " показывать незавершенные команды в статусбаре (автодополнение ввода)
set matchpairs+=<:> " показывать совпадающие скобки для HTML-тегов
set showmatch       " показывать первую парную скобку после ввода второй
set autoread        " перечитывать изменённые файлы автоматически
set confirm         " использовать диалоги вместо сообщений об ошибках

"
function! LastPosition()
    " не меняем позицию при коммите
    if expand("<afile>:s? \d+??") != '.git\COMMIT_EDITMSG'
        if expand("<afile>:t") != ".git" && line("'\"")<=line('$')
            normal! `"
        endif
    endif
endfunction

function! UpdateFileInfo()
    if exists("g:loaded_ctags_highlighting")
        UpdateTypesFile
    endif
endfunction

" опции сессий - перейти в текущию директорию, использовать буферы
set sessionoptions=curdir,buffers,help,options,resize,slash,unix,winpos,winsize
if version >= 700
    " и табы
    set sessionoptions+=tabpages
endif

" При вставке фрагмента сохраняет отступы
"set pastetoggle=

"Настройки сворачивания блоков кода (фолдинг)
"set foldenable " включить фолдинг
"set foldmethod=syntax " определять блоки на основе синтаксиса файла
"set foldcolumn=3 " показать полосу для управления сворачиванием
"set foldlevel=1 " Первый уровень вложенности открыт, остальные закрыты
"let perl_folding=1 " правильное сворачивание классов и функций Perl
"let php_folding=1 " правильное сворачивание классов и функций PHP
"set foldopen=all " автоматическое открытие сверток при заходе в них

" Для указанных типов файлов отключает замену табов пробелами и меняет ширину отступа
au FileType crontab,fstab,make set noexpandtab tabstop=8 shiftwidth=8

"" Применять типы файлов
filetype on
filetype plugin on
filetype indent on
" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! BufWritePost $MYVIMRC source $MYVIMRC
" Прыгать на последнюю позицию при открытии буфера
autocmd! BufReadPost * call LastPosition()
autocmd BufReadPost * call UpdateFileInfo()
"" Если сохраняемый файл является файлом скрипта - сделать его исполняемым
"" au BufWritePost * if getline(1) =~ "^#!.*/bin/"|silent !chmod a+x %|endif
"" При открытии файла задавать для него соответствующий 'компилятор'
autocmd! BufEnter *.pl compiler perl
autocmd! BufEnter *.pm compiler perl
"autocmd BufWritePre *.pl :%s/\s\+$//e
"autocmd BufWritePre *.pm :%s/\s\+$//e
"autocmd BufWritePre *.py :%s/\s\+$//e
execute "autocmd VimLeavePre * silent mksession! " . vimfiles_dir . 'lastSession.vim'
" Single line comments for C and C++
au FileType c,cpp setlocal comments-=:// comments+=f://
" Wrong spaces group for coding
au FileType c,cpp,h,hpp,html,js,perl,php,python,vim,xml match WrongSpaces /[ \t]\+$\| \t[ \t]*/
hi WrongSpaces ctermbg=red guibg=red

" highlight trailing spaces
"autocmd BufNewFile,BufRead * let b:mtrailingws=matchadd(ErrorMsg, \s\+$, -1)
" highlight tabs between spaces
"autocmd BufNewFile,BufRead * let b:mtabbeforesp=matchadd(ErrorMsg, \v(\t+)\ze( +), -1)
"autocmd BufNewFile,BufRead * let b:mtabaftersp=matchadd(ErrorMsg, \v( +)\zs(\t+), -1)
" disable matches in help buffers
"autocmd BufEnter,FileType help call clearmatches()

"" Переключение кодировок файла
set wildmenu
set wildmode=longest:full,full
set wildignore=*.swp,*.bak,*.pyc,*.class
set wcm=<Tab>
menu Encoding.CP1251   :e ++enc=cp1251<CR>
menu Encoding.CP866    :e ++enc=cp866<CR>
menu Encoding.KOI8-U   :e ++enc=koi8-u<CR>
menu Encoding.UTF-8    :e ++enc=utf-8<CR>
map <F8> :emenu Encoding.<TAB>

" end dimio-blog

set lazyredraw

"set encoding=cp1251
"set termencoding=utf-8
if has("multi_byte")
    if &termencoding == ""
        let &termencoding = &encoding
    endif
    set encoding=utf-8
    setglobal fileencoding=utf-8 bomb
    set fileencodings=utf-8,cp1251,koi8-r,latin1
else
    set fileencodings=cp1251,koi8-r,cp866
endif
set fileformats=unix,dos,mac " формат файла по умолчанию (влияет на окончания строк) - будет перебираться в указанном порядке

" Ловля имени редактируемого файла из vim'а. (^[ вводится как Ctrl+V Esc)
set title
"set titlestring=%t-dsd
"set titleold=&titlestring
" screen:
"set titlestring=%t
"set titleold=bash
"
function! NextTabOpened()
    if &term == "screen" || $TERM == 'screen-256color'
        let &titlestring = "[vim(" . expand("%:t") . ")]"
    else
        let &titlestring = "vim(" . expand("%:t") . ")"
    endif
endfunction
"
"let &titlestring = "[vim(" . expand("%:t") . ")]"
if &term == "screen" || $TERM == 'screen-256color'
    set t_ts=k
    set t_fs=\
endif
if &term == "xterm" || &term == "screen" || $TERM == 'screen-256color'
    set title
endif
call NextTabOpened()

autocmd! BufEnter * call NextTabOpened()

if has('gui')
    " For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
    if has('win32')
        let &guioptions = substitute(&guioptions, "t", "", "g")
    endif
    set guioptions-=T " отключить тулбар в GUI
    "set guioptions-=m " отключить меню
    au GUIEnter * :set lines=99999 columns=99999
    " В разных графических системах используем разные шрифты:
    if has('win32')
        set guifont=DejaVu_Sans_Mono:h13:cRUSSIAN::
        if matchstr(&guifont,'DejaVu\.*') != 'DejaVu'
            set guifont=Consolas:h13:cRUSSIAN::
            " set guifont=Consolas:h13::cGB2312::
            if matchstr(&guifont,'Consolas\.*') != 'Consolas'
                set guifont=Lucida_Console:h12:cRUSSIAN::
            endif
        endif
        behave xterm
    else
        let s:uname=system("uname -s")
        if strpart(s:uname, 0, 6) == "Darwin"
            set guifont=Monaco:h14
        else
            set guifont=Hack\ 13
            if matchstr(&guifont,'Hack\.*') != 'Hack'
                set guifont=Consolas\ 14
                if matchstr(&guifont,'Consolas\.*') != 'Consolas'
                    set guifont=Terminus\ 14
                endif
            endif
        endif
    endif
endif

" сохраняемся по F2
nmap <F2> <ESC>:w<CR>
imap <F2> <ESC>:w<CR>i<Right>
" F6/F7 - предыдущая/следующая ошибка
nmap <F6> <ESC>:cp<CR>
imap <F6> <ESC>:cp<CR>
nmap <F7> <ESC>:cn<CR>
imap <F7> <ESC>:cn<CR>
nmap <S-F6> <ESC>:lprevious<CR>
imap <S-F6> <ESC>:lprevious<CR>
nmap <S-F7> <ESC>:lnext<CR>
imap <S-F7> <ESC>:lnext<CR>
nmap <F9> <ESC>:make<CR>
imap <F9> <ESC>:make<CR>
" ?
inoremap <silent> <C-u> <ESC>u:set paste<CR>.:set nopaste<CR>gi
"
nnoremap <silent> <Leader>d <ESC>:w<CR>:VCSDiff<CR>
nnoremap <silent> <Leader>e <ESC>:TlistToggle<CR>
nnoremap <silent> <Leader>h <ESC>:noh<CR>
nnoremap <silent> <Leader>q <ESC>:quit<CR>
nnoremap <silent> <Leader>w <C-W><C-W>:res<CR>
nnoremap <silent> <Leader>z <ESC>:SyntasticReset<CR>

function! SyntaxItem()
    return synIDattr(synID(line("."),col("."),1),"name")
endfunction

if has('statusline')
    set statusline=
    set statusline+=%f\                 " filename
    set statusline+=%y\                 " type of file
    set statusline+=%r                  " read-only flag
    set statusline+=%m                  " modified flag
    set statusline+=\ [%{&ff}]          " file type - unix/win e.t.c.
    set statusline+=[%{&fenc}]\         " file encoding
    set statusline+=%{SyntaxItem()}\    " syntax item
    if filereadable(vimfiles_dir.'bundle/vim-git-branch-info/plugin/git-branch-info.vim')
        set statusline+=%=%{GitBranchInfoString()}\ " git branch name
    endif
    set statusline+=%12(0x%02B\ (%b)%)  " byte under cursor, hex+decimal
    set statusline+=%16(%l/%L,%c%V%)    " line number + column/virtual column
    set statusline+=\ %P                " percentage
    set statusline+=%{&hlsearch?'+':'-'}
    set statusline+=%{&paste?'=':'\ '}
    set statusline+=%{&wrap?'<':'>'}
    if has('gui_running')
        set statusline+=\ %{strftime(\"%H:%M:%S\")}
    elseif $TERM != 'screen' && $TERM != 'screen-256color'
        set statusline+=\ %{strftime(\"%H:%M\")}
    endif
endif
" %{GitBranch()}\
set laststatus=2
let g:git_branch_status_nogit=""
let g:git_branch_status_head_current=1

" tab navigation like firefox
if version >= 700
    nmap <C-S-Tab> :tabprevious<cr>
    nmap <C-Tab> :tabnext<cr>
    map <C-S-Tab> :tabprevious<cr>
    map <C-Tab> :tabnext<cr>
    imap <C-S-Tab> <ESC>:tabprevious<cr>i
    imap <C-Tab> <ESC>:tabnext<cr>i
    nnoremap <C-n> :tabnew<cr>
    inoremap <C-t> <ESC>:tabnew<cr>
"    nnoremap <C-S-w> :tabclose<cr>
    inoremap <C-w> <ESC>:tabclose<cr>
    nmap Z :tabprev<cr>
    nmap X :tabnext<cr>

    set showtabline=2 " always show tabs
endif

"ino <tab> <c-r>=TriggerSnippet()<cr>
"snor <tab> <esc>i<right><c-r>=TriggerSnippet()<cr>

" настраиваем каталоги только если есть корневой
if isdirectory(vimfiles_dir)
    " хранить swap-файлы будем в одном месте, чтобы не мешались
    let swap_dir=vimfiles_dir.'swapfiles'

    if !isdirectory(swap_dir) && exists('*mkdir')
        call mkdir(swap_dir)
    endif

    if isdirectory(swap_dir)
        let &directory=swap_dir.'//'
    endif

    " то же самое для бэкапов
    if has("vms")
        set nobackup    " do not keep a backup file, use versions instead
    else
        set backup      " keep a backup file
        let backup_dir=vimfiles_dir.'backupfiles'

        if !isdirectory(backup_dir) && exists('*mkdir')
            call mkdir(backup_dir)
        endif

        if isdirectory(backup_dir)
            let &backupdir=backup_dir.'/'
        endif
    endif

    " то же самое для undo
    if version >= 703
        set undofile
        let undo_dir=vimfiles_dir.'undofiles'

        if !isdirectory(undo_dir) && exists('*mkdir')
            call mkdir(undo_dir)
        endif

        if isdirectory(undo_dir)
            let &undodir=undo_dir.'/'
        endif
    endif
endif

let g:mwDefaultHighlightingPalette = 'extended'
let g:mwVerbose = 0

" tagbar win at left side
let g:tagbar_left = 1
" chars instead +/-
let g:tagbar_iconchars = ['▶', '◢']
" No sort
"let g:tagbar_sort = 0

nnoremap <silent> <Leader>t <ESC>:TagbarToggle<CR>
inoremap <silent> <Leader>t <ESC>:TagbarToggle<CR>

if executable('ag')
    let g:ackprg = 'ag --nogroup --nocolor --column'
endif

if executable('fortune') && executable('cowsay')
    function! s:filter_header(lines) abort
        let longest_line   = max(map(copy(a:lines), 'len(v:val)'))
        let centered_lines = map(copy(a:lines),
            \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
        return centered_lines
    endfunction

    let g:startify_custom_footer =
          \ s:filter_header(map(split(system('fortune | cowsay'), '\n'), '"   ". v:val') + ['',''])
endif
" startify do not change dir to opened file
let g:startify_change_to_dir = 0
" change to the root directory of the VCS
let g:startify_change_to_vcs_root = 1

let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_aggregate_errors = 1
let g:syntastic_warning_symbol = 'W>'

" dvg - end
" vim: ts=4 sw=4
" end of file
