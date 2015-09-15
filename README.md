# CtrlP PHP Namespace Import

![demo](https://dl.dropboxusercontent.com/u/1819148/ctrlp-phpnamespace.gif)

This is a prototype based on
[arnaud-lib/vim-php-namespace](https://github.com/arnaud-lb/vim-php-namespace),
but uses CtrlP to select from the list of matches. It intentionally doesn't do
expansion, as I don't really do that anymore.

``` 
inoremap <buffer> <leader>u <C-O>:let g:backToInsert=1<CR><C-O>:call PhpInsertUse()<CR><C-O>a
noremap <buffer> <leader>u :call PhpInsertUse()<CR>
```
