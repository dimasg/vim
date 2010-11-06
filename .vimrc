if has('win32')
    language messages en
    let vimfiles_dir=expand("$HOME/vimfiles/")
else
    language messages en_US.UTF-8
    let vimfiles_dir=expand("$HOME/.vim/")
endif

" from http://stevelosh.com/blog/2010/09/coming-home-to-vim/

if filereadable(vimfiles_dir."autoload/pathogen.vim")
    filetype off
    call pathogen#helptags()
    call pathogen#runtime_append_all_bundles()
    filetype plugin indent on
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" bit prevents some security exploits 
set modelines=0

set ttyfast
set gdefault

if v:version >= 730
    set undofile
endif

"set formatoptions=qrn1

" save all at focus lost
au FocusLost * :wa

" end stevelosh

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup    " do not keep a backup file, use versions instead
else
    set backup      " keep a backup file
endif
set history=50      " keep 50 lines of command line history
set ruler           " show the cursor position all the time

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
let &guioptions = substitute(&guioptions, "t", "", "g")
" Избавляемся от меню и тулбара:
"set guioptions-=T
"set guioptions-=m

" Don't use Ex mode, use Q for formatting
map Q gq

set number
"set relativenumber

if has('win32') || has("gui_running")
    set t_Co=256    " использовать больше цветов в терминале
endif
if &t_Co > 2
    syntax enable
    set hlsearch
endif
if filereadable(expand("$VIMRUNTIME/colors/darkblue.vim"))
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
    highlight lCursor ctermfg=yellow ctermbg=red guifg=NONE guibg=cyan
endif
set title

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
if version >= 700
"   По умолчанию проверка орфографии выключена.
    setlocal spell spelllang=
    setlocal nospell
    "
    function ChangeSpellLang()
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
    map <F11> <Esc>:call ChangeSpellLang()<CR>
endif
" по умолчанию латинская раскладка
set iminsert=0
" по умолчанию поиск латиницей
set imsearch=0
set tabstop=4
set shiftwidth=4
set autoindent
"set sw=4
set smarttab
set expandtab
" граница переноса
set wrapmargin=5
" подсветим 85ю колонку
if v:version >= 730
    set colorcolumn=85
endif
" автоматический перенос после 128 колонки
set textwidth=128
" сколько строк повторять при скроллинге
set scrolloff=4
" подсветка строки и колонки курсора
if v:version >= 700
    set cursorline
endif
"set cursorcolumn
set visualbell
" миннимальная высота окна
set winminheight=0
" делать активное окон максимального размера
set noequalalways
set winheight=999

set incsearch        " do incremental searching
set smartcase

" http://dimio-blog.livejournal.com/16376.html

set hidden          " не выгружать буфер когда переключаешься на другой
set mouse=a         " включает поддержку мыши при работе в терминале (без GUI)
set mousehide       " скрывать мышь в режиме ввода текста
set showcmd         " показывать незавершенные команды в статусбаре (автодополнение ввода)
set matchpairs+=<:> " показывать совпадающие скобки для HTML-тегов
set showmatch       " показывать первую парную скобку после ввода второй
set autoread        " перечитывать изменённые файлы автоматически
set confirm         " использовать диалоги вместо сообщений об ошибках

" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

" Прыгать на последнюю позицию при открытии буфера
autocmd! bufreadpost * call LastPosition()
"
function! LastPosition()
    " не меняем позицию при коммите 
    if expand("<afile>:s? \d+??") != '.git\COMMIT_EDITMSG'
        if expand("<afile>:t") != ".git" && line("'\"")<=line('$')
            normal! `"
        endif
    endif
endfunction
    
if version >= 700
    set sessionoptions=curdir,buffers,tabpages " опции сессий - перейти в текущию директорию, использовать буферы и табы
else
    set sessionoptions=curdir,buffers
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
"" Если сохраняемый файл является файлом скрипта - сделать его исполняемым
"" au BufWritePost * if getline(1) =~ "^#!.*/bin/"|silent !chmod a+x %|endif
"" При открытии файла задавать для него соответствующий 'компилятор'
autocmd! BufEnter *.pl compiler perl

"" Переключение кодировок файла
set wildmenu
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
set fileencodings=utf-8,cp1251,koi8-r,cp866
set fileformats=unix,dos,mac " формат файла по умолчанию (влияет на окончания строк) - будет перебираться в указанном порядке

if !has("gui_running")
    set mouse=a
endif

if has('gui')
    set guioptions-=T " отключить меню в GUI
    au GUIEnter * :set lines=99999 columns=99999
endif
" В разных графических системах используем разные шрифты:
if has('win32')
    set guifont=Lucida_Console:h11:cRUSSIAN::
    behave xterm
else
    set guifont=Terminus\ 14
endif

" сохраняемся по F2
nmap <F2> <ESC>:w<CR>
imap <F2> <ESC>:w<CR>i<Right>
" ?
inoremap <silent> <C-u> <ESC>u:set paste<CR>.:set nopaste<CR>gi

set statusline=%f\ %L%y%r\ [%{&ff}][%{&fenc}]\ %=%m\ %-15(0x%02B\ (%b)%)%-15(%l,%c%V%)%P
" %{GitBranch()}\ 
set laststatus=2

" tab navigation like firefox
if version >= 700
    nmap <C-S-tab> :tabprevious<cr>
    nmap <C-tab> :tabnext<cr>
    map <C-S-tab> :tabprevious<cr>
    map <C-tab> :tabnext<cr>
    imap <C-S-tab> <ESC>:tabprevious<cr>i
    imap <C-tab> <ESC>:tabnext<cr>i
    nmap <C-t> :tabnew<cr>
    imap <C-t> <ESC>:tabnew<cr>
    map <C-w> :tabclose<cr>
    imap <C-w> :tabclose<cr>
    nmap Z :tabprev<cr>
    nmap X :tabnext<cr>
endif

"ino <tab> <c-r>=TriggerSnippet()<cr>
"snor <tab> <esc>i<right><c-r>=TriggerSnippet()<cr>

" хранить swap-файлы будем в одном месте, чтобы не мешались
let swap_dir=vimfiles_dir.'swapfiles/'

if !isdirectory(swap_dir) && exists('*mkdir')
    call mkdir(swap_dir)
endif

if isdirectory(swap_dir)
    let &dir=swap_dir
endif

" dvg - end
" end of file
