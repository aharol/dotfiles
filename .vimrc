set directory=~/.vim/backup
set backupdir=~/.vim/backup   " keep swap files here
filetype off                  " required

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'tpope/vim-fugitive'
Plug 'bling/vim-airline'
Plug 'mileszs/ack.vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'scrooloose/nerdtree'
Plug 'easymotion/vim-easymotion'
Plug 'benmills/vimux'
" Plug 'morhetz/gruvbox'
Plug 'dracula/vim'
Plug 'rodjek/vim-puppet'
Plug 'kchmck/vim-coffee-script'
Plug 'airblade/vim-gitgutter'
Plug 'rizzatti/dash.vim'
Plug 'parsonsmatt/intero-neovim'
Plug 'neovimhaskell/haskell-vim'
Plug 'Twinside/vim-hoogle'
Plug 'derekwyatt/vim-scala'
Plug 'kien/rainbow_parentheses.vim'
Plug 'guns/vim-clojure-static'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
Plug 'neomake/neomake'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'wikitopian/hardmode'
Plug 'w0ng/vim-hybrid'
Plug 'Valloric/MatchTagAlways'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'fatih/vim-go'
" Plug 'zchee/deoplete-go', {'build': {'unix': 'make'}}
" Plug 'jodosha/vim-godebug'

" ===================================================================
" Scheme language
" Plug 'Olical/vim-scheme', { 'for': 'scheme', 'on': 'SchemeConnect' }
" You'll need vim-sexp too for selecting forms.
Plug 'guns/vim-sexp'
" And while you're here, tpope's bindings make vim-sexp a little nicer to use.
Plug 'tpope/vim-sexp-mappings-for-regular-people'
" ===================================================================

let g:go_fmt_command = "goimports"
let g:go_addtags_transform = "snakecase"
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1

Plug 'godoctor/godoctor.vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }

let g:LanguageClient_rootMarkers = ['*.cabal', 'stack.yaml']
set rtp+=~/.vim/plugged/LanguageClient-neovim
let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

" if has('nvim')
"     Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
" else
"     Plug 'Shougo/deoplete.nvim'
"     Plug 'roxma/nvim-yarp'
"     Plug 'roxma/vim-hug-neovim-rpc'
" endif
" let g:deoplete#enable_at_startup = 1

Plug 'eagletmt/neco-ghc'


" All of your Plugs must be added before the following line
call plug#end()              " required

" Non-Plug stuff after this line
" ================================

" Neomake on save
autocmd! BufWritePost * Neomake

" Nerdtree git plugin symbols
let g:NERDTreeIndicatorMapCustom = {
            \ "Modified"  : "ᵐ",
            \ "Staged"    : "ˢ",
            \ "Untracked" : "ᵘ",
            \ "Renamed"   : "ʳ",
            \ "Unmerged"  : "ᶴ",
            \ "Deleted"   : "ˣ",
            \ "Dirty"     : "˜",
            \ "Clean"     : "ᵅ",
            \ "Unknown"   : "?"
            \ }

let NERDTreeMapOpenInTab='\r'

" Gitgutter show more signs
let g:gitgutter_max_signs = 1500

" Function for number toggle
function! NumberToggle()
    if(&relativenumber == 1)
        set norelativenumber
    else
        set relativenumber
    endif
endfunc

nnoremap <C-N> :call NumberToggle()<cr>

" Function for whitespace toggle
function! WhitespaceToggle()
    set listchars=eol:¬,tab:--,trail:~,extends:>,precedes:<
    if(&list ==1)
        set nolist
    else
        set list
    endif
endfunc

nnoremap <C-T> :call WhitespaceToggle()<cr>

function! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun

command! TrimWhitespace call TrimWhitespace() " Trim whitespace with command
autocmd BufWritePre * :call TrimWhitespace() " Trim whitespace on every save

" Non-mapped function for tab toggles
function! TabToggle()
    if &expandtab
        set noexpandtab
    else
        set expandtab
    endif
endfunc

" Remappings
"    Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)

"    Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

"    Disable arrows
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>
"    Nerdtree
map <C-F> :NERDTreeToggle<CR>

" Other options
set relativenumber
set number
let mapleader=','
set backspace=2

set termguicolors

set background=dark        " for the light version
let g:airline_theme='dracula'
" let g:airline_theme='gruvbox'
let g:one_allow_italics = 1 " I love italic for comments
colorscheme dracula
" colorscheme gruvbox
" colorscheme macvim-light

syntax on
set shell=/bin/zsh
set laststatus=2
set noshowmode

set cursorline

set splitbelow

syntax on

" Draw a line at 80 columns
set colorcolumn=120
" highlight ColorColumn ctermbg=235 guibg=#2c2d27

" Check the function above, these
" are my default values
set tabstop=4
set shiftwidth=4
set expandtab

set encoding=utf8
let g:airline_powerline_fonts = 1
set shell=/bin/zsh

set smartindent
" hi Normal guibg=NONE ctermbg=NONE

" autocmd BufWritePost *.py call flake8()
