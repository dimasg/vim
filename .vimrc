" from http://stevelosh.com/blog/2010/09/coming-home-to-vim/

"filetype off
"call pathogen#runtime_append_all_bundles()
"filetype plugin indent on

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" bit prevents some security exploits 
set modelines=0

set ttyfast
"set relativenumber
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
    set nobackup        " do not keep a backup file, use versions instead
else
    set backup        " keep a backup file
endif
set history=50        " keep 50 lines of command line history
set ruler        " show the cursor position all the time
set showcmd        " display incomplete commands
set incsearch        " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" from juchkov

syntax enable
set number
if filereadable(expand("$VIMRUNTIME/colors/darkblue.vim"))
    colorscheme darkblue
endif
set title

" from - end

" me - dvg

" Показываем табы в начале строки точками
"set listchars=tab:··i
"set listchars=tab:»\ ,trail:·,eol:¶
"set list

" change rus-las with Ctrl-^
"set keymap=russian-jcukenwin 
set iminsert=0
set tabstop=4
set shiftwidth=4
set autoindent
"set sw=4
set smarttab
set expandtab
" граница переноса
set wrapmargin=5
if v:version >= 730
    set colorcolumn=85
endif
" сколько строк повторять при скроллинге
set scrolloff=4
" подсветка строки и колонки курсора
set cursorline
"set cursorcolumn
set visualbell

set hlsearch
set incsearch
set smartcase

" http://dimio-blog.livejournal.com/16376.html

set hidden " не выгружать буфер когда переключаешься на другой
set mouse=a " включает поддержку мыши при работе в терминале (без GUI)
set mousehide " скрывать мышь в режиме ввода текста
set showcmd " показывать незавершенные команды в статусбаре (автодополнение ввода)
set matchpairs+=<:> " показывать совпадающие скобки для HTML-тегов
set showmatch " показывать первую парную скобку после ввода второй
set autoread " перечитывать изменённые файлы автоматически
set t_Co=256 " использовать больше цветов в терминале
set confirm " использовать диалоги вместо сообщений об ошибках
"" Автоматически перечитывать конфигурацию VIM после сохранения
autocmd! bufwritepost $MYVIMRC source $MYVIMRC

"" Прыгать на последнюю позицию при открытии буфера
autocmd! bufreadpost * call LastPosition()
	function! LastPosition()
		if line("'\"")<=line('$')
			normal! `"
		endif
	endfunction
set sessionoptions=curdir,buffers,tabpages " опции сессий - перейти в текущию директорию, использовать буферы и табы

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

set lz

"set encoding=cp1251
"set termencoding=utf-8
set fileencodings=utf-8,cp1251,koi8-r,cp866
set fileformats=unix,dos,mac " формат файла по умолчанию (влияет на окончания строк) - будет перебираться в указанном порядке

if !has("gui_running")
    set mouse=a
endif

" Избавляемся от меню и тулбара:
"set guioptions-=T
"set guioptions-=m

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


nmap <F2> <ESC>:w<CR>
imap <F2> <ESC>:w<CR>i<Right>

inoremap <silent> <C-u> <ESC>u:set paste<CR>.:set nopaste<CR>gi

set statusline=%f\ %L%y%r\ [%{&ff}][%{&fenc}]\ %=%m\ %-15(0x%02B\ (%b)%)%-15(%l,%c%V%)%P
set laststatus=2

" dvg - end

" tab navigation like firefox
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

" end of file
