# Set up the prompt

# promptinit
# prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz promptinit
# compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# PROMPT=%#
# RPROMPT=[%?]

mkcd() {
    mkdir $1
    cd $1
}

# Autostart if not already in tmux.
# if [[ ! -n $TMUX ]]; then
#   tmux new-session
#fi

# aliases

alias gh='ghq'
alias sZsh='source ~/.zshrc'

# gopath
export GOPATH="$GOROOT"

# anyenv
export PATH="$HOME/.anyenv/bin:$PATH"
eval "$(anyenv init - zsh)"

# scalaenv
# export PATH="${HOME}/.scalaenv/bin:${PATH}"
# eval "$(scalaenv init -)"

# linuxbrew
export PATH='/home/linuxbrew/.linuxbrew/bin:/home/linuxbrew/.linuxbrew/sbin':"$PATH"

source ~/.zplug/init.zsh

# ghq
# export GHQ_ROOT = "$HOME/ghq"

# 読み込み順序を設定する
# 例: "zsh-syntax-highlighting" は compinit の後に読み込まれる必要がある
# (2 以上は compinit 後に読み込まれるようになる)
zplug "zsh-users/zsh-syntax-highlighting"
zplug "zsh-users/zsh-history-substring-search"
zplug "mollifier/cd-gitroot"
zplug "mollifier/anyframe"
zplug "zsh-users/zsh-completions"

zplug "tsub/f4036e067a59b242a161fc3c8a5f01dd", from:gist # history-fzf.zsh
zplug "tsub/81ac9b881cf2475977c9cb619021ef3c", from:gist # ssh-fzf.zsh
zplug "tsub/90e63082aa227d3bd7eb4b535ade82a0", from:gist # git-branch-fzf.zsh
zplug "tsub/29bebc4e1e82ad76504b1287b4afba7c", from:gist # tree-fzf.zsh

ghq-fzf() {
    local selected_dir=$(ghq list | fzf --query="$LBUFFER")

    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq root)/${selected_dir}"
    fi

    zle reset-prompt
}

zle -N ghq-fzf
bindkey "^g" ghq-fzf

# fzf本体
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# fzf-bin にホスティングされているので注意
# またファイル名が fzf-bin となっているので file:fzf としてリネームする
zplug "junegunn/fzf-bin"

# 依存管理
# "emoji-cli" は "jq" があるときにのみ読み込まれる
zplug "stedolan/jq", \
    from:gh-r, \
    as:command, \
    rename-to:jq
zplug "b4b4r07/emoji-cli", \
    on:"stedolan/jq"

# テーマファイルを読み込む
# zplug "dracula/zsh", as:theme
# zplug "agkozak/agkozak-zsh-prompt"

zplug denysdovhan/spaceship-prompt, use:spaceship.zsh, from:github, as:theme

SPACESHIP_DIR_TRUNC=0
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_PROMPT_DEFAULT_PREFIX=( )

SPACESHIP_GIT_PREFIX=( )

SPACESHIP_PACKAGE_PREFIX=( )

SPACESHIP_EXEC_TIME_PREFIX=( )
SPACESHIP_EXEC_TIME_ELAPSED=0

SPACESHIP_PROMPT_ORDER=(dir line_sep package node ruby elixir golang php rust haskell docker venv conda pyenv exit_code exec_time git line_sep char)

<< comment

setopt prompt_subst # Make sure prompt is able to be generated properly.
zplug "caiogondim/bullet-train.zsh", use:bullet-train.zsh-theme, defer:3 # defer until other plugins like oh-my-zsh is loaded

BULLETTRAIN_PROMPT_ORDER=(dir git status virtualenv nvm ruby go)

comment

# 未インストール項目をインストールする
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# zplug 'zplug/zplug', hook-build:'zplug --self-manage

# コマンドをリンクして、PATH に追加し、プラグインは読み込む
zplug load --verbose

screenfetch