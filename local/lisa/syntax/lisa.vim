" Vim syntax file
" Language: LISA
" Maintainer: Andrey Gladilin <agladilin@sw-soft.com>
" Last Change:  2005 Aug 12

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif



syn keyword lsaStatement Icon ICON INDEX NOT NULL PK SK GK return exclude NOTAB Static Slave Manual Select RowName WhenEmpty access granted denied writable readonly not_referencible Name WIDTH RDBMS rdbmspp LEN java_gui_def java_gui MYSQL XMLVALIDATOR XMLTYPE SVALIDATOR XMLTYPE ENCRYPT DBLEN COLOR
syn keyword lsaType Int INT INT_POSITIVE Double DOUBLE STR DATE TIME ID NAME BOOL MONEY STRA STR10 STR20 STR30 STR40 STR60 STR80 ENUM all
syn keyword lsaStorageClass UnArch Abstract Virtual Internal const
syn keyword lsaStatement Class Attributes Methods Views DataWindow Window Folder Groups
syn keyword lsaInclude parent embed
syn keyword lsaConstant INT_NULL
syn keyword lsaConstant ADMIN_Write ADMIN_Read PROVIDER_Read PROVIDER_Setup PROVIDER_Support PROVIDER_Financial PROVIDER_Marketing PROVIDER_Sales PROVIDER_Setup_R PROVIDER_Support_R PROVIDER_Financial_R PROVIDER_Marketing_R PROVIDER_Sales_R CUSTOMER_Write CUSTOMER_Read Decrypt NOBODY
syn keyword lsaSpecWord StandardInput MoveToArc Add Get Update

syn match   lsaSpecial display contained "\\\(x\x\+\|\o\{1,3}\|.\|$\)"
syn region  lsaString   start=+L\="+ skip=+\\\\\|\\"+ end=+"+ contains=lsaSpecial

syn region  lsaComment start="/\*" end="\*/" contains=cSpecial
syn region  lsaCommentLine start="//" skip="\\$" end="$" keepend contains=lsaSpecial
syn region  lsaCommentStrange start="\#" skip="\\$" end="$" keepend contains=lsaSpecial


" Default highlighting
if version >= 508 || !exists("did_cpp_syntax_inits")
  if version < 508
    let did_cpp_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  HiLink lsaInclude     Include
  HiLink lsaStatement   Statement
  HiLink lsaStructure   Structure
  HiLink lsaStorageClass StorageClass
  HiLink lsaType        Type
  HiLink lsaConstant    Constant
  HiLink lsaSpecWord    Identifier
  HiLink lsaString      String
  HiLink lsaCommentString Comment
  HiLink lsaComment     Comment
  HiLink lsaCommentLine Comment
  HiLink lsaCommentStrange Comment
  delcommand HiLink
endif

