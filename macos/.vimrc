syntax on
colorscheme slate
set background=dark

set expandtab
set ignorecase
set hls
set ic
set incsearch
set modeline
set nowrap
set ruler
set number
set showcmd
set showmatch
set smartcase
set smartindent
set smarttab
set wildmenu

set backspace=indent,eol,start
set clipboard=unnamed
set laststatus=2
set path=.,,$PWD/**
set shiftwidth=2
set softtabstop=2
set tabstop=2
set textwidth=90
set mouse=a
if has("mouse_sgr")
    set ttymouse=sgr
else
    set ttymouse=xterm2
end
map <ScrollWheelDown> j
map <ScrollWheelUp> k

if has("autocmd")
  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " highlight unnecessary whitespace
  highlight ExtraWhitespace ctermbg=red guibg=red
  match ExtraWhitespace /\s\+$/
  au BufWinEnter,InsertLeave * match ExtraWhitespace /\s\+$/
  au InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
  " prevent colorscheme from overriding these highlights
  au ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif
endif
