" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" perl plugin

filetype plugin on
let g:Perl_AuthorName      = 'Dmitry Grachev'
let g:Perl_AuthorRef       = 'dgrachev'
let g:Perl_Email           = 'dgrachev@masterhost.ru'
let g:Perl_Company         = '.masterhost'
let g:Perl_PerlcriticOptions = '-profile /home/autotest/perlcriticrc '
let g:Perl_PerlcriticSeverity = 1
let g:Perl_PerlcriticVerbosity = 1

let Tlist_Ctags_Cmd = '/home/dgrachev/bin/ctags'

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" from juchkov

syntax enable
set number
set ruler
colorscheme darkblue
set autoindent
"set mouse=a
set title
set hlsearch
nmap <F2> <ESC>:w<CR>
imap <F2> <ESC>:w<CR>i<Right>
" me
"nmap <F3> :bp!<CR> " предыдуший буффер
"imap <F3> <Esc>:bp!<CR>a
map <F3> :r ~/.vim/skel/func.pl<CR>$a
nmap <F4> :bn!<CR> " следующий буффер
imap <F4> <Esc>:bn!<CR>a
nmap <F7> <C-W>k<C-W>_ " окно вверх
imap <F7> <Esc><C-W>k<C-W>_a " окно вверх
nmap <F8> <C-W>j<C-W>_ " окно вниз
imap <F8> <Esc><C-W>j<C-W>_a " окно вниз
nmap <F12> <ESC>:!perlcritic -profile /home/autotest/perlcriticrc ./%<CR>
" nmap <F12> <ESC>:!perlcritic -profile ~/billing/t/perlcriticrc ./%<CR>
" end me
nmap <F9> <ESC>:!perl -c ./%<CR>
imap <F9> <ESC>:!perl -cw ./%<CR>
nmap <F5> <ESC>:!./%<CR>
imap <F5> <ESC>:!./%<CR>
nmap <F6> <ESC>:!./% \|less<CR>
imap <F6> <ESC>:!./% \|less<CR>

nmap <F10> <ESC>:!perl -d ./%<CR>

" from - end

" me - dvg

" change rus-las with Ctrl-^
"set keymap=russian-jcukenwin 
set iminsert=0
set tabstop=4
set sw=4

set termencoding=utf-8

set statusline=%f\ %L%y%r%=%m\ %-15(0x%02B\ (%b)%)%-15(%l,%c%V%)%P
set laststatus=2

" dvg - end

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Ловля имени редактируемого файла из vim'а. Файл .vimrc (^[ вводится как Ctrl+V Esc)

"set titlestring=%t-dsd
set titleold=bash

let &titlestring = "vim (" . expand("%:t") . ")"

if &term == "screen"
	set t_ts=k
	set t_fs=\
endif

if &term == "screen" || &term == "xterm"
	set title
endif

"set term=xterm

"setlocal spell spelllang=ru

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


