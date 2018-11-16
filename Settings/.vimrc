set tabstop=4 " visual spaces per TAB
set softtabstop=4 " number of spaces in tab when edit
set number " show line numbers
set wildmenu " visual autocomplete for command menu
set showmatch " highlight matching [{(
set foldmethod=marker " folding method
set foldmarker={,} " folding between { and }

" mappings
nmap ö ddO
nmap <S-Enter> O<Esc>
nmap <CR> o<Esc>

nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<    Space>")<CR>

