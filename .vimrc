" ------------------------------
" 一般
" ------------------------------
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
set clipboard+=unnamed         " OSのクリップボードを使用する

" ---------------------------------------
" syntax color
" ---------------------------------------
syntax on
"colorscheme molokai
colorscheme jellybeans

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
let &statusline = '%{cfi#format("[%s()] ", "[no function] ")}'
set statusline+=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P
set scrolloff=10
set laststatus=2
set notitle
set showmatch            " 括弧をハイライト
set number            " 行番号表示
"set list            " 不可視文字表示
"set listchars=tab:>.,trail:_,extends:>,precedes:<   " 不可視文字の表示形式
"set display=uhex                " 印字不可能文字を16進数で表示
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

" submodeを利用してctrl+w+r h,j,k,lでリサイズモード escで抜ける
function! s:resizeWindow()
    call submode#enter_with('winsize', 'n', '', 'mws', '<Nop>')
    call submode#leave_with('winsize', 'n', '', '<Esc>')

    let curwin = winnr()
    wincmd j | let target1 = winnr() | exe curwin "wincmd w"
    wincmd l | let target2 = winnr() | exe curwin "wincmd w"

    execute printf("call submode#map ('winsize', 'n', 'r', 'j', '<C-w>%s')", curwin == target1 ? "-" : "+")
    execute printf("call submode#map ('winsize', 'n', 'r', 'k', '<C-w>%s')", curwin == target1 ? "+" : "-")
    execute printf("call submode#map ('winsize', 'n', 'r', 'h', '<C-w>%s')", curwin == target2 ? ">" : "<")
    execute printf("call submode#map ('winsize', 'n', 'r', 'l', '<C-w>%s')", curwin == target2 ? "<" : ">")
endfunction

nmap <C-w>r  :<C-u>call <SID>resizeWindow()<CR>mws

" 保存時に行末の空白を除去する
"autocmd BufWritePre * :%s/\s\+$//e
function! s:remove_dust()
    let cursor = getpos(".")
    " 保存時に行末の空白を除去する
    %s/\s\+$//ge
    " 保存時にtabを2スペースに変換する
    "%s/\t/  /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()

" 最後に編集した場所にカーソルを移動する
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


"---------------------------------------s
" tab
"----------------------------------------
"set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set shiftround
"set nowrap
set wrap

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
"NeoBundle 'tsukkee/unite-tag.git'
NeoBundle 'Shougo/neomru.vim'
" 補完 neocomplcache.vim : 究極のVim的補完環境
NeoBundle 'Shougo/neocomplcache'
" neocomplcacheのsinpet補完
"NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/neosnippet.vim'
NeoBundle "Shougo/neosnippet-snippets"
"NeoBundle "Shougo/neocomplcache-rsense.vim"
NeoBundle 'tomasr/molokai'
NeoBundle 'nanotech/jellybeans.vim'
NeoBundle 'fugalh/desert.vim'
NeoBundle 'tpope/vim-surround'
NeoBundle 'vim-scripts/gtags.vim'
" DumbBuf.vim : quickbufっぽくbufferを管理。 "<Leader>b<Space>でBufferList
"NeoBundle 'DumbBuf'
" minibufexpl.vim : タブエディタ風にバッファ管理ウィンドウを表示
NeoBundle 'minibufexpl.vim'
" NERDTree : ツリー型エクスプローラ
NeoBundle 'The-NERD-tree'
" NeoBundle 'nginx.vim'
" syntax統合
NeoBundle 'scrooloose/syntastic'
NeoBundle 'motemen/git-vim'
" Twigのシンタックスハイライト
"NeoBundle 'beyondwords/vim-twig'
"NeoBundle 'ocim/htmljinja.vim'
"NeoBundle 'atourino/jinja.vim'
"NeoBundle 'kana/vim-submode'
"NeoBundle 'shawncplus/php.vim'
" ショートカット実行
NeoBundle 'thinca/vim-quickrun.git'
" php折り畳み
NeoBundle 'everzet/phpfolding.vim'
" 関数名
NeoBundle 'tyru/current-func-info.vim.git'
"NeoBundle 'vim-ruby/vim-ruby'
"NeoBundle 'tpope/vim-rails'

"NeoBundle 'mattn/zencoding-vim'
"NeoBundle 'open-browser.vim'
"NeoBundle 'mattn/webapi-vim'
"NeoBundle 'tell-k/vim-browsereload-mac'
"NeoBundle 'hail2u/vim-css3-syntax'
"NeoBundle 'hokaccha/vim-css3-syntax'
"NeoBundle 'taichouchou2/html5.vim'
"NeoBundle 'taichouchou2/vim-javascript'
"NeoBundle 'kchmck/vim-coffee-script'


" ファイル判定on
filetype plugin indent on

"----------------------------------------
" neocomplcache有効
"----------------------------------------
let g:neocomplcache_enable_at_startup = 1

" tabで補完出来るように
function! InsertTabWrapper()
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

" path にヘッダーファイルのディレクトリを追加することで
" neocomplcache が include 時に tag ファイルを作成してくれる
set path+=$LIBSTDCPP
set path+=$BOOST_LATEST_ROOT

" neocomplcache が作成した tag ファイルのパスを tags に追加する
function! s:TagsUpdate()
    " include している tag ファイルが毎回同じとは限らないので毎回初期化
    setlocal tags=
    for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
        execute "setlocal tags+=".neocomplcache#cache#encode_name('tags_output', filename)
    endfor
endfunction

command!
    \ -nargs=? PopupTags
    \ call <SID>TagsUpdate()
    \ |Unite tag:<args>

function! s:get_func_name(word)
    let end = match(a:word, '<\|[\|(')
    return end == -1 ? a:word : a:word[ : end-1 ]
endfunction

" カーソル下のワード(word)で絞り込み
noremap <silent> g<C-]> :<C-u>execute "PopupTags ".expand('<cword>')<CR>

" カーソル下のワード(WORD)で ( か < か [ までが現れるまでで絞り込み
" 例)
" boost::array<std::stirng... → boost::array で絞り込み
noremap <silent> G<C-]> :<C-u>execute "PopupTags "
    \.substitute(<SID>get_func_name(expand('<cWORD>')), '\:', '\\\:', "g")<CR>


"----------------------------------------
" neosnippet
"----------------------------------------

" snippetを保存するディレクトリを設定してください
let s:default_snippet = '~/.vim/bundle/vim-snippets/snippets'
let s:my_snippet = '~/.snippet' " 自分のsnippet
let g:neosnippet#snippets_directory = s:my_snippet
let g:neosnippet#snippets_directory = s:default_snippet . ',' . s:my_snippet

" Plugin key-mappings.
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)

" SuperTab like snippets behavior.
imap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: pumvisible() ? "\<C-n>" : "\<TAB>"
smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
\ "\<Plug>(neosnippet_expand_or_jump)"
\: "\<TAB>"

" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif


"----------------------------------------
" syntastic
"----------------------------------------
let g:syntastic_check_on_open=0 "ファイルを開いたときはチェックしない
let g:syntastic_check_on_save=1 "保存時にはチェック
let g:syntastic_auto_loc_list=1 "エラーがあったら自動でロケーションリストを開く
let g:syntastic_loc_list_height=6 "エラー表示ウィンドウの高さ
set statusline+=%#warningmsg# "エラーメッセージの書式
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_javascript_checker = 'jshint' "jshintを使う
"let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']
let g:syntastic_php_checkers=['php', 'phpmd']
let g:syntastic_php_phpmd_post_args='text unusedcode'
let g:syntastic_mode_map = {'mode': 'active',
      \ 'active_filetypes': ['php', 'javascript', 'js', 'scss', 'css'],
      \ 'passive_filetypes': ['html']
      \ }
"エラー表示マークを変更
let g:syntastic_enable_signs=1
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

" Twig
"au BufRead,BufNewFile *.twig set filetype=jinja
"au BufRead,BufNewFile *.html.twig set filetype=htmljinja
" PHP


"----------------------------------------
" zencoding
"----------------------------------------
" let g:user_zen_leader_key = '<C-Y>'
" " 言語別に対応させる
" let g:user_zen_settings = {
"       \  'lang' : 'ja',
"       \  'html' : {
"       \    'filters' : 'html',
"       \    'indentation' : ' '
"       \  },
"       \  'css' : {
"       \    'filters' : 'fc',
"       \  },
"       \}

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
"let dumbbuf_hotkey = '<Leader>b<Space>'
"let dumbbuf_mappings = {
"    \ 'n': {
"        \'<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
"    \}
"\}
"let dumbbuf_single_key  = 1
"let dumbbuf_updatetime  = 1    " &updatetimeの最小値
"let dumbbuf_wrap_cursor = 0
"let dumbbuf_remove_marked_when_close = 1

"------------------------------------
" unite.vim
"------------------------------------
" 入力モードで開始する
let g:unite_enable_start_insert=1
" 大文字小文字を区別しない
let g:unite_enable_ignore_case = 1
let g:unite_enable_smart_case = 1
" バッファ一覧
noremap <space>b :Unite buffer<CR>
" ファイル一覧
noremap <space>f :UniteWithBufferDir -buffer-name=files file<CR>
" ファイル一覧vimルート
noremap <space>g :Unite -buffer-name=files file<CR>
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

noremap <silent> <C-]> :<C-u>Unite -immediately -no-start-insert tag:<C-r>=expand('<cword>')<CR><CR>

" grep検索
nnoremap <silent> ,g  :<C-u>Unite grep:. -buffer-name=search-buffer<CR>
" カーソル位置の単語をgrep検索
nnoremap <silent> ,cg :<C-u>Unite grep:. -buffer-name=search-buffer<CR><C-R><C-W>
" grep検索結果の再呼出
nnoremap <silent> ,r  :<C-u>UniteResume search-buffer<CR>
" unite grep に ag(The Silver Searcher) を使う
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--nogroup --nocolor --column'
  let g:unite_source_grep_recursive_opt = ''
endif

"------------------------------------
" Unite-rails.vim
"------------------------------------
"{{{
function! UniteRailsSetting()
  nnoremap <buffer><C-H><C-H><C-H>  :<C-U>Unite rails/view<CR>
  nnoremap <buffer><C-H><C-H>       :<C-U>Unite rails/model<CR>
  nnoremap <buffer><C-H>            :<C-U>Unite rails/controller<CR>

  nnoremap <buffer><C-H>c           :<C-U>Unite rails/config<CR>
  nnoremap <buffer><C-H>s           :<C-U>Unite rails/spec<CR>
  nnoremap <buffer><C-H>m           :<C-U>Unite rails/db -input=migrate<CR>
  nnoremap <buffer><C-H>l           :<C-U>Unite rails/lib<CR>
  nnoremap <buffer><expr><C-H>g     ':e '.b:rails_root.'/Gemfile<CR>'
  nnoremap <buffer><expr><C-H>r     ':e '.b:rails_root.'/config/routes.rb<CR>'
  nnoremap <buffer><expr><C-H>se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
  nnoremap <buffer><C-H>ra          :<C-U>Unite rails/rake<CR>
  nnoremap <buffer><C-H>h           :<C-U>Unite rails/heroku<CR>
endfunction
aug MyAutoCmd
  au User Rails call UniteRailsSetting()
aug END
"}}}

" --------------------------------
" git-vim
" --------------------------------
noremap <Leader>gd: git diff
noremap <Leader>gD: git diff --cached
noremap <Leader>gs: git status
noremap <Leader>gl: git log
noremap <Leader>ga: git add
noremap <Leader>gA: git add
noremap <Leader>gc: git commit
noremap <Leader>gp: git pull --rebase


" --------------------------------
" ctags
" --------------------------------
set tags=~/.tags
" tをtmuxでbindしてるので別keyにあてる
nnoremap <C-[> :pop<CR>

" --------------------------------
" vim-ruby
" --------------------------------
" MyAutocmd FileType ruby,eruby setlocal omnifunc=rubycomplete#Complete
" let g:rubycomplete_rails = 0
" let g:rubycomplete_buffer_loading = 1
" let g:rubycomplete_classes_in_global = 1
" let g:rubycomplete_include_object = 1
" let g:rubycomplete_include_object_space = 1
