if v:lang =~ "utf8$" || v:lang =~ "UTF-8$"
   set fileencodings=ucs-bom,utf-8,GB18030,latin1
endif 

set nocompatible    " Use Vim defaults (much better!)
set bs=indent,eol,start     " allow backspacing over everything in insert mode
"set ai         " always set autoindenting on
"set backup     " keep a backup file
set viminfo='20,\"50    " read/write a .viminfo file, don't store more
            " than 50 lines of registers
set history=100     " keep 50 lines of command line history
set ruler       " show the cursor position all the time

" Only do this part when compiled with support for autocommands
if has("autocmd")
  augroup fedora
  autocmd!
  " In text files, always limit the width of text to 78 characters
  " autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
  " don't write swapfile on most commonly used directories for NFS mounts or USB sticks
  autocmd BufNewFile,BufReadPre /media/*,/run/media/*,/mnt/* set directory=~/tmp,/var/tmp,/tmp
  " start with spec file template
  autocmd BufNewFile *.spec 0r /usr/share/vim/vimfiles/template.spec
  augroup END
endif

if has("cscope") && filereadable("/usr/bin/cscope")
   set csprg=/usr/bin/cscope
   set csto=0
   set cst
   set nocsverb
   " add any database in current directory
   if filereadable("cscope.out")
      cs add $PWD/cscope.out
   " else add database pointed to by environment
   elseif $CSCOPE_DB != ""
      cs add $CSCOPE_DB
   endif
   set csverb
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

filetype plugin on

if &term=="xterm"
     set t_Co=8
     set t_Sb=^[[4%dm
     set t_Sf=^[[3%dm
endif

" Don't wake up system with blinking cursor:
" http://www.linuxpowertop.org/known.php
let &guicursor = &guicursor . ",a:blinkon0"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 显示相关  
" """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set shortmess=atI   " 启动的时候不显示那个援助乌干达儿童的提示  
set foldenable      " 允许折叠  
set foldmethod=manual   " 手动折叠  
" 显示中文帮助
if version >= 603
   set helplang=cn
   set encoding=utf-8
endif
" 设置配色方案
colorscheme murphy
"字体 
if (has("gui_running")) 
set guifont=Bitstream\ Vera\ Sans\ Mono\ 10 
endif 
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set termencoding=utf-8
set encoding=utf-8
set fileencodings=ucs-bom,utf-8,cp936
set fileencoding=utf-8
""""新文件标题"""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
"autocmd BufNewFile *.*,*.py,*.php,*.cpp,*.[ch],*.sh,*.java exec ":call SetTitle()" 
autocmd BufNewFile *.* exec ":call SetTitle()" 
"""定义函数SetTitle，自动插入文件头 
func SetTitle() 
    "如果文件类型为.sh文件 
    if &filetype == 'sh' 
        call setline(1, "\#!/bin/bash")
        call append(line("."), "\#")
        call append(line(".")+1,"\# ###  ###############################") 
        call append(line(".")+2, "\# File Name: ".expand("%")) 
        call append(line(".")+3, "\# Author: TONGTF") 
        call append(line(".")+4, "\# Mail:hsyh.tong@gmail.com")
        call append(line(".")+5, "\# Created Time: ".strftime(" %F %T"))
        call append(line(".")+6, "\# Last Modified:".strftime(" %F %T"))
        call append(line(".")+7, "\# ###  ###############################") 
        call append(line(".")+8, "\#set -x") 
        call append(line(".")+9, "set -e") 
        call append(line(".")+10, "") 
    
    elseif &filetype == 'python'
        call setline(1, "#!/usr/bin/env python")
        call append(line("."), "# -*- coding:utf-8 -*-")
        call append(line(".")+1,"'''                               -------------------------")
        call append(line(".")+2, "    > File Name: ".expand("%")) 
        call append(line(".")+3, "    > Author: TONGTF") 
        call append(line(".")+4, "    > Mail: hsyh.tong@gmail.com") 
        call append(line(".")+5, "    > Created Time: ".strftime(" %F %T")) 
        call append(line(".")+6, "    > Last Modified:".strftime(" %F %T"))")
        call append(line(".")+7, "-----------------------                                 '''")
        call append(line(".")+8, "")
    elseif &filetype == 'lua'
        call setline(1, "-- ----------------------------------------------------")
        call append(line("."), "--    > File Name: ".expand("%")) 
        call append(line(".")+1, "--    > Author: TONGTF") 
        call append(line(".")+2, "--    > Mail: hsyh.tong@gmail.com") 
        call append(line(".")+3, "--    > Created Time: ".strftime(" %F %T")) 
        call append(line(".")+4, "--    > Last Modified:".strftime(" %F %T"))")
        call append(line(".")+5, "-- ----------------------------------------------------")
        call append(line(".")+6, "")
    elseif &filetype == 'cpp' 
        call setline(1, "/** **                                          ***************************") 
        call append(line("."), "    > File Name: ".expand("%")) 
        call append(line(".")+1, "    > Author: TONGTF") 
        call append(line(".")+2, "    > Mail: hsyh.tong@gmail.com") 
        call append(line(".")+3, "    > Created Time: ".strftime(" %F %T")) 
        call append(line(".")+4, "    > Last Modified:".strftime(" %F %T"))")
        call append(line(".")+5, " *****************************                                       ****/") 
        call append(line(".")+6, "#include<iostream>")
        call append(line(".")+7, "using namespace std;")
        call append(line(".")+8, "")
    endif
    
"新建文件后，自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunc
"Last Modified
autocmd BufWritePre,FileWritePre * ks|call LastModified()|'s
fun LastModified()
    let l = line("$")
    exe "1," . l . 'g@^\s*\(\*\|#\|"\|\/\/\)\?\s*[L]ast Modified:@s@^\(\s*\(\*\|#\|"\|\/\/\)\?\s*[L]ast Modified:\).*@\1' .strftime(" %F %T")."@e"
    redraw
endfun

"C，C++ 按F5编译运行
map <F5> :call CompileRunGcc()<CR>
func! CompileRunGcc()
    exec "w"
    if &filetype == 'c'
       exec "!g++ % -o %<"
       exec "! ./%<"
    elseif &filetype == 'cpp'
       exec "!g++ % -o %<"
       exec "! ./%<"
    elseif &filetype == 'java' 
       exec "!javac %" 
       exec "!java %<"
    elseif&filetype == 'sh'
       :!./%
    endif
endfunc
""C,C++的调试
map <F8> :call Rungdb()<CR>
    func! Rungdb()
        exec "w"
        exec "!g++ % -g -o %<"
        exec "!gdb ./%<"
    endfunc
"设置当前文件被改动时自动载入
set autoread
"quickfix模式
autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
"代码补全
set completeopt=preview,menu
"语法高亮
set syntax=on
"Tab键的宽度
set tabstop=4
"统一缩进为4
set softtabstop=4
set shiftwidth=4
"显示行号
set number
"相对行号
set relativenumber
"侦测文件类型
filetype on
"通过使用：commands命令，显示修改过的行
set report=0
"高亮显示匹配的括号
set showmatch
" show matching bracket for 0.2 seconds
set matchtime=2
set autoindent
set copyindent
""显示TAB
set list
set expandtab
" When on, a <Tab> in front of a line inserts blanks
" according to 'shiftwidth'. 'tabstop' is used in other
" places. A <BS> will delete a 'shiftwidth' worth of space                  " at the start of the line.
set smarttab
" Show (partial) command in status line.
set showcmd
" While typing a search command, show immediately where the
" so far typed pattern matches.
set incsearch
" Ignore case in search patterns.
set ignorecase
" Override the 'ignorecase' option if the search pattern
" contains upper case characters.
set smartcase
set formatoptions=c,q,r,t
" Show the line and column number of the cursor position,
" separated by a comma.
set ruler

" change the terminal's title
set title
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! %!sudo tee > /dev/null %
" 开启相对行号
"set relativenumber

" 设定文件浏览器目录为当前目录
set autochdir
"当前行高亮
set cursorline
"no temp
set nobackup
set noswapfile

" vundle 环境设置
set rtp+=~/.vim/bundle/Vundle.vim
" " vundle 管理的插件列表必须位于 vundle#begin() 和 vundle#end() 之间
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
" " 插件列表结束
call vundle#end()
">>>> INDENT options
" 随 vim 自启动
let g:indent_guides_enable_on_vim_startup=1
" 从第二层开始可视化显示缩进
let g:indent_guides_start_level=2
" 色块宽度
let g:indent_guides_guide_size=1
">>>> NERDTree options
autocmd vimenter * NERDTree

autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

">>>> airline options
let g:airline#extensions#tabline#enabled = 1
