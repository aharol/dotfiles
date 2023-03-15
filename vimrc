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
" Plug 'arzg/vim-colors-xcode'
Plug 'dracula/vim', { 'as': 'dracula' }
Plug 'airblade/vim-gitgutter'
Plug 'rizzatti/dash.vim'
Plug 'parsonsmatt/intero-neovim'
Plug 'neovimhaskell/haskell-vim'
Plug 'Twinside/vim-hoogle'
Plug 'terryma/vim-multiple-cursors'
Plug 'kien/rainbow_parentheses.vim'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'junegunn/vim-easy-align'
Plug 'neomake/neomake'
Plug 'ryanoasis/vim-devicons'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'wikitopian/hardmode'
Plug 'w0ng/vim-hybrid'
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'
Plug 'Chiel92/vim-autoformat'
Plug 'JuliaEditorSupport/julia-vim'
Plug 'autozimu/LanguageClient-neovim', { 'branch': 'next', 'do': './install.sh' }
Plug 'eagletmt/neco-ghc'

let g:LanguageClient_rootMarkers = ['*.cabal', 'stack.yaml']
set rtp+=~/.vim/plugged/LanguageClient-neovim
let g:LanguageClient_serverCommands = { 'haskell': ['hie-wrapper'] }

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

" All of your Plugs must be added before the following line
call plug#end()              " required

" Non-Plug stuff after this line
" ================================

" Neomake on save
autocmd! BufWritePost * Neomake

" Nerdtree git plugin symbols
let g:NERDTreeGitStatusIndicatorMapCustom = {
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

let g:NERDTreeMapOpenInTab='\r'
let g:NERDTreeHighlightCursorline=0

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
" set relativenumber
set number
let mapleader=','
set backspace=2

set termguicolors
set background=dark        " for the light version

colorscheme dracula
let g:airline_theme='dracula'
" let g:airline_theme='xcodelighthc'
" let g:xcodelighthc_emph_types=1
" let g:xcodelighthc_emph_funcs=1
" let g:xcodelighthc_emph_idents=1
" let g:xcodelighthc_match_paren_style=1
" let g:xcodelighthc_green_comments=1
"
" augroup vim-colors-xcode
"     autocmd!
" augroup END
"
" autocmd vim-colors-xcode ColorScheme * hi Comment        cterm=italic gui=italic
" autocmd vim-colors-xcode ColorScheme * hi SpecialComment cterm=italic gui=italic

set shell=/bin/zsh
set laststatus=2
set noshowmode

syntax on
highlight lineNr term=bold cterm=none ctermbg=none ctermfg=none gui=bold
set cursorline
highlight CursorLine term=bold cterm=none ctermbg=none ctermfg=none gui=bold
highlight CursorLineNr term=bold cterm=none ctermbg=none ctermfg=yellow gui=bold

set splitbelow

" Check the function above, these
" are my default values
set tabstop=4
set shiftwidth=4
set expandtab

set encoding=utf8
let g:airline_powerline_fonts = 1
set shell=/bin/zsh

set smartindent
