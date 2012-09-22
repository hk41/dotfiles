"----------------------------------------
" 一般
"----------------------------------------
filetype off

set nocompatible
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                     " ビープをならさない
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
set clipboard+=unnamed		 " OSのクリップボードを使用する

" ---------------------------------------
" syntax color
" ---------------------------------------
syntax on 
colorscheme molokai

" ターミナルタイプによるカラー設定
if &term =~ "xterm-256color" || "screen-256color"
  set t_Co=256
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-debian" || &term =~ "xterm-xfree86"
  set t_Co=16
  set t_Sf=[3%dm
  set t_Sb=[4%dm
elseif &term =~ "xterm-color"
  set t_Co=
  set t_Sf=[3%dm
  set t_Sb=[4%dm
endif

"----------------------------------------
" display
"----------------------------------------
"set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set scrolloff=10
set laststatus=2
set notitle
set showmatch						" 括弧をハイライト
set number						" 行番号表示
"set list						" 不可視文字表示
"set listchars=tab:>.,trail:_,extends:>,precedes:< 	" 不可視文字の表示形式
"set display=uhex      					" 印字不可能文字を16進数で表示
" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/


"----------------------------------------
" encoding
"----------------------------------------
set termencoding=utf-8
set encoding=utf-8

"----------------------------------------
" edit
"----------------------------------------
set autoindent
set smartindent
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
let loaded_matchparen = 1

"----------------------------------------
" tab
"----------------------------------------
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set shiftround
set nowrap

"----------------------------------------
" search
"----------------------------------------
set hlsearch
nmap <Esc><Esc> :nohlsearch<CR><Esc>
set incsearch
set ignorecase
set wrapscan
set smartcase

"----------------------------------------
" neobundle
"----------------------------------------
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim/
    call neobundle#rc(expand('~/.vim/bundle/'))
endif

" NERD_commenter.vim :最強コメント処理 (<Leader>c<space>でコメントをトグル)
NeoBundle 'scrooloose/nerdcommenter.git'
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
" 補完 neocomplcache.vim : 究極のVim的補完環境
NeoBundle 'Shougo/neocomplcache'
" neocomplcacheのsinpet補完
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'tomasr/molokai'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/gtags.vim'
" DumbBuf.vim : quickbufっぽくbufferを管理。 "<Leader>b<Space>でBufferList
NeoBundle 'DumbBuf'
" minibufexpl.vim : タブエディタ風にバッファ管理ウィンドウを表示
NeoBundle 'minibufexpl.vim'
" NERDTree : ツリー型エクスプローラ
NeoBundle 'The-NERD-tree'

" ファイル判定on
filetype plugin indent on

"----------------------------------------
" neocomplcache有効 
"----------------------------------------
let g:neocomplcache_enable_at_startup = 1

" tabで補完出来るように
function InsertTabWrapper()
    if pumvisible()
        return "\<c-n>"
    endif
    let col = col('.') - 1
    if !col || getline('.')[col - 1] !~ '\k\|<\|/'
        return "\<tab>"
    elseif exists('&omnifunc') && &omnifunc == ''
        return "\<c-n>"
    else
        return "\<c-x>\<c-o>"
    endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>

"------------------------------------
" MiniBufExplorer
"------------------------------------
"set minibfexp
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

":MtでMiniBufExplorerの表示トグル
command! Mt :TMiniBufExplorer

"------------------------------------
" DumbBuf.vim
"------------------------------------
"<Leader>b<Space>でBufferList
let dumbbuf_hotkey = '<Leader>b<Space>'
let dumbbuf_mappings = {
    \ 'n': {
        \'<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
    \}
\}
let dumbbuf_single_key  = 1
let dumbbuf_updatetime  = 1    " &updatetimeの最小値
let dumbbuf_wrap_cursor = 0
let dumbbuf_remove_marked_when_close = 1

"------------------------------------
" unite.vim
"------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" バッファ一覧
noremap <space>b :Unite buffer<CR>
" ファイル一覧
noremap <space>f :UniteWithBufferDir -buffer-name=files file<CR>
" 最近使ったファイルの一覧
noremap <space>r :Unite file_mru<CR>
" レジスタ一覧
noremap <space>y :Unite -buffer-name=register register<CR>
" ファイルとバッファ
noremap <space>u :Unite buffer file_mru<CR>
" 全部
noremap <space>a :Unite UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>:q<CR>
