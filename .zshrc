# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt interactivecomments

setopt histignorealldups sharehistory
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
export HISTSIZE=10000
export SAVEHIST=10000
export HISTFILE="$HOME/.zsh_history"
export HISTORY_IGNORE="(cd|ls|pwd|exit|rm|n?vim|git reset)"

case ${OSTYPE} in
  darwin*)
    if [[ $(uname -m) = "arm64" ]]; then
      alias rosetta="arch -x86_64 /bin/zsh"
      alias python3.8="/usr/bin/python3"
      export PYTHONROOT="/Library/Frameworks/Python.framework/Versions/"
    elif [[ $(uname -m) = "x86_64" ]]; then
      export PYTHONROOT="/usr/local/bin"
      export HOMEBREW_PREFIX="/usr/local"
    fi


    export PATH="$HOMEBREW_PREFIX/sbin:$PATH"
    # tailscale
    alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"
    # Visual Studio Code
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    export FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
    # [[ -r "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$HOMEBREW_PREFIX/etc/profile.d/bash_completion.sh"
    ;;
  linux*)
    if [[ -e /etc/debian_version ]]; then
      # eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
      # export HOMEBREW_PREFIX="$HOME/linuxbrew/.linuxbrew"
    fi
    ;;
esac

zstyle ':completion:*' special-dirs true
zstyle ':completion:*' auto-description 'specify: %d'
# zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:options'         description 'yes'
zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters
# Highlight
zstyle ':completion:*'              list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*:messages'     format "$YELLOW" '%d' "$DEFAULT"
zstyle ':completion:*:warnings'     format "$RED" 'No matches for:' "$YELLOW" '%d' "$DEFAULT"
zstyle ':completion:*:descriptions' format "$YELLOW" 'Completing %B%d%b' "$DEFAULT"
zstyle ':completion:*:corrections'  format "$YELLOW" '%B%d% ' "$RED" '(Errors: %e)%b' "$DEFAULT"
# Separator
zstyle ':completion:*'         list-separator ' ==> '
zstyle ':completion:*:manuals' separate-sections true
# Cache
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$HOME/.zsh/cache"
# Others
zstyle ':completion:*' remote-access false
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

autoload -Uz compinit && compinit
autoload -Uz bashcompinit && bashcompinit

export PATH="$HOME/.local/bin:$PATH"

function mkcd() {
  mkdir -p "$1"
  cd "$1" || return
}

autoload -Uz vcs_info
function gitroot() {
  if test "$(git rev-parse --git-dir 2> /dev/null)"; then
    git rev-parse --show-superproject-working-tree --show-toplevel | head -1
  fi
}

# visual editor
autoload -Uz edit-command-line; zle -N edit-command-line
# bindkey -M vicmd v edit-command-line
bindkey "^x^e" edit-command-line

alias reloadzsh='exec -l zsh'

# MySQL and Postgres Lib
export PATH="$HOMEBREW_PREFIX/opt/mysql-client/bin:$PATH"
export XML_CATALOG_FILES="$HOMEBREW_PREFIX/etc/xml/catalog"
export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

# terraform
complete -o nospace -C "$HOMEBREW_PREFIX/bin/terraform" terraform

export DENO_NO_PROMPT=1

# zenn-cli
alias zenn="deno run -A --unstable-fs npm:zenn-cli@latest"

# stoplight prism
alias prism="deno run -A --unstable-fs npm:@stoplight/prism-cli@latest"

# np for npm/yarn/pnpm/bun
alias ni="bunx @antfu/ni"

alias wrangler="bunx @wrangler"

# yq
alias yq="gojq --yaml-input --yaml-output"

# Go
export GOPATH="$HOME/ghq"
export PATH="$PATH:$GOPATH/bin"

# Rust
export PATH="$HOME/.cargo/bin:$PATH"

# neovim
export PATH="$PATH:$HOME/.local/nvim/bin"
export XDG_CONFIG_HOME="$HOME/.config"
export NVIM_CACHE_HOME="$HOME/.vim/bundles"
export PATH="$PATH:$HOME/.local/nvim/bin"
export EDITOR=nvim
export LANG=ja_JP.UTF-8

# man
export MANPAGER='nvim -c ASMANPAGER -'

# aws completion
complete -C "$(command -v aws_completer)" aws

# gcloud for Google Cloud SDK
if [[ -e $HOMEBREW_PREFIX ]]; then
  export GCLOUD_PREFIX="$HOMEBREW_PREFIX/Caskroom/google-cloud-sdk/latest/google-cloud-sdk"
elif [[ -e /etc/arch-release ]]; then
  export GCLOUD_PREFIX="/opt/google-cloud-sdk"
fi
source "$GCLOUD_PREFIX/path.zsh.inc"
source "$GCLOUD_PREFIX/completion.zsh.inc"

# nvm for nodejs
export NVM_DIR="$HOME/.nvm"
if [[ -e $HOMEBREW_PREFIX ]]; then
  [ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && . "$HOMEBREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
  [ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
elif [[ -e /etc/arch-release ]]; then
  source /usr/share/nvm/init-nvm.sh
  source /usr/share/nvm/nvm.sh
  source /usr/share/nvm/bash_completion
  source /usr/share/nvm/install-nvm-exec
fi

# 1Password
eval "$(op completion zsh)"; compdef _op op
source "$HOME/.config/op/plugins.sh"

# direnv
_direnv_hook() {
  trap -- '' SIGINT;
  eval "$(direnv export zsh)";
  trap - SIGINT;
}
typeset -ag precmd_functions;
if [[ -z "${precmd_functions[(r)_direnv_hook]+1}" ]]; then
  precmd_functions=( _direnv_hook "${precmd_functions[@]}" )
fi
typeset -ag chpwd_functions;
if [[ -z "${chpwd_functions[(r)_direnv_hook]+1}" ]]; then
  chpwd_functions=( _direnv_hook "${chpwd_functions[@]}" )
fi

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit for light-mode zdharma-continuum/zinit-annex-as-monitor \
  zdharma-continuum/zinit-annex-bin-gem-node \
  zdharma-continuum/zinit-annex-patch-dl \
  zdharma-continuum/zinit-annex-rust \
  zdharma-continuum/history-search-multi-word \
  mollifier/anyframe \
  srijanshetty/zsh-pip-completion \
  hlissner/zsh-autopair \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions

eval "$(op completion zsh)"; compdef _op op

# Truncate Directory
hash -d github=$HOME/ghq/github.com
hash -d work=$HOME/ghq/github.com/topgate
hash -d personal=$HOME/ghq/github.com/peacock0803sz

# source $(ghq root)/github.com/peacock0803sz/zeno.zsh/zeno.zsh
# export ZENO_ROOT="$(ghq root)/github.com/peacock0803sz/zeno.zsh/zeno.zsh"
zinit ice lucid depth"1" blockf
zinit light yuki-yano/zeno.zsh

# export ZENO_ENABLE_FZF_TMUX=1
export ZENO_ENABLE_SOCK=1
export ZENO_FZF_TMUX_OPTIONS="-p 90%,90%"
export ZENO_GIT_CAT="bat -p --color=always"
export ZENO_GIT_TREE="exa --tree"
if [[ -n $ZENO_LOADED ]]; then
  bindkey ' '  zeno-auto-snippet
  bindkey '^m' zeno-auto-snippet-and-accept-line
  bindkey '^x^s' zeno-insert-snippet
  bindkey '^i' zeno-completion
fi

function ghq-fzf() {
  local dir

  if [[ -n ${TMUX} ]]; then
    dir=$(ghq list -p | sed -e "s|${HOME}|~|" | fzf-tmux "$ZENO_FZF_TMUX_OPTIONS" --preview "$ZENO_GIT_CAT \$(eval echo {})/README.md" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up)
  else
    dir=$(ghq list -p | sed -e "s|${HOME}|~|" | fzf --preview "$ZENO_GIT_CAT \$(eval echo {})/README.md" --bind ctrl-d:preview-page-down,ctrl-u:preview-page-up)
  fi

  if [[ $dir == "" ]]; then
    return 1
  fi

  BUFFER="cd $dir"
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N ghq-fzf
bindkey "^g" ghq-fzf

function history-fzf() {
  if [[ ! -z ${TMUX} ]]; then
    BUFFER=$(history -n 1 | fzf-tmux --query="$LBUFFER")
  else
    BUFFER=$(history -n 1 | fzf --query="$LBUFFER")
  fi

  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

function ssh-fzf() {
  local selected_host=$(grep "Host " ~/.ssh/config | grep -v '*' | cut -b 6- | fzf --query="$LBUFFER")
  if [[ -n "$selected_host" ]]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ssh-fzf
bindkey '^x^s' ssh-fzf

export VENV_ROOT="${HOME}/venvs"
export VENVFZF_VENV_OPTIONS=""

function venv-fzf() {
  if [[ ! -z ${TMUX} ]] && [[ $(which fzf-tmux) ]]; then
    local dir=$(_list_venvs | fzf-tmux -p 90%,90% --prompt="vnev> ")
  else
    local dir=$(_list_venvs | fzf --prompt="vnev> ")
  fi
  if [[ -n $dir ]]; then
    BUFFER=". $dir/bin/activate"
    CURSOR=$#BUFFER
    zle accept-line
  fi
  zle reset-prompt
}

function _list_venvs() {
  local dirs=$(find $VENV_ROOT -maxdepth 4 -mindepth 4 -type d)

  for d in $dirs; do
    echo "$d"
  done
}
zle -N venv-fzf
bindkey '^x^v' venv-fzf

function mkvenv() {
  local _venv_dir=$(pwd | awk -F "/" '{print $(NF-2),$(NF-1),$NF}' | tr ' ' '/')
  local venv_name="$_venv_dir/venv"
  read -r _venv_name\?"Input a name of dir (default: ${venv_name})> "
  if [[ -n ${_venv_name} ]]; then
    venv_name=${_venv_name}
  fi

  local expected_venv="${VENV_ROOT}/${venv_name}"
  if [[ -d expected_venv ]]; then
    echo "${expected_venv} is Already exist !!"
    return
  elif [[ ! -e expected_venv ]]; then
    mkdir -p "$expected_venv"
  fi

  find "$PYTHONROOT" -maxdepth 1 | grep -e '[0-9]$'
  local _py_number
  read -r _py_number\?"Choise a number you wants use python > "

  local _py="$PYTHONROOT$_py_number/bin/python3"

  echo "$_py -m venv ${expected_venv}"
  $_py -m venv "$expected_venv"
  source "$expected_venv/bin/activate"
}

export PIP_REQUIRE_VIRTUALENV=1

# theme
zinit load romkatv/powerlevel10k

[ -f ~/.fzf.zsh ] && source "$HOME/.fzf.zsh"

# place this after nvm initialization!
autoload -U add-zsh-hook
load-nvmrc() {
  local node_version
  node_version="$(nvm version)"
  local nvmrc_path
  nvmrc_path="$(nvm_find_nvmrc)"

  if [ -n "$nvmrc_path" ]; then
    local nvmrc_node_version
    nvmrc_node_version=$(nvm version "$(cat "${nvmrc_path}")")

    if [ "$nvmrc_node_version" = "N/A" ]; then
      nvm install
    elif [ "$nvmrc_node_version" != "$node_version" ]; then
      nvm use --silent
    fi
  elif [ "$node_version" != "$(nvm version default)" ]; then
    echo "Reverting to nv eault version"
    nvm use default
  fi
}

# To customize prompt, run `p10k configure` or edit ~/dotfiles/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source "$HOME/dotfiles/.p10k.zsh"
