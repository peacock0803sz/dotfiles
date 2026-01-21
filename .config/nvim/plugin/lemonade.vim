" Clipboard configuration for lemonade (SSH remote clipboard)
" SSH環境でlemonadeが利用可能な場合はlemonadeを使用

if exists('$SSH_CLIENT') && executable('lemonade')
  " SSH_CLIENTからリモートホストのIPを抽出 (例: "192.168.1.100 54321 22" -> "192.168.1.100")
  let s:remote_host = split($SSH_CLIENT)[0]

  if !empty(s:remote_host)
    let g:clipboard = {
          \ 'name': 'lemonade',
          \ 'copy': {
          \   '+': ['lemonade', '--host', s:remote_host, 'copy'],
          \   '*': ['lemonade', '--host', s:remote_host, 'copy'],
          \ },
          \ 'paste': {
          \   '+': ['lemonade', '--host', s:remote_host, 'paste'],
          \   '*': ['lemonade', '--host', s:remote_host, 'paste'],
          \ },
          \ 'cache_enabled': v:false,
          \ }

    " プロバイダーが既にロードされていたらリロード
    if exists('g:loaded_clipboard_provider')
      unlet g:loaded_clipboard_provider
      runtime autoload/provider/clipboard.vim
    endif

    set clipboard=unnamed
  endif
elseif has('clipboard')
  " ローカル環境ではシステムクリップボードを使用
  set clipboard=unnamed
endif
