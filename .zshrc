# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

autoload -Uz compinit
autoload bashcompinit && bashcompinit
zstyle ':completion:*' verbose yes
zstyle ':completion:*' menu select=2
zstyle ':completion:*' group-name ''
zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list
zstyle ':completion:*' matcher-list  'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' special-dirs true

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
# eval "$(dircolors -b)"
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

function mkcd() {
  mkdir -p $1
  cd $1
}

export PATH="$HOME/.local/bin:$PATH"

autoload -Uz vcs_info
function gitroot() {
  if test $(git rev-parse --git-dir 2> /dev/null); then
    git rev-parse --show-superproject-working-tree --show-toplevel | head -1
  fi
}

# aliases

alias reloadzsh='exec -l zsh'
alias acvenv='source venv/bin/activate'
alias vimconf='vim $HOME/.vimrc'
alias nvimconf='nvim $HOME/.config/nvim/init.vim'
alias zshconf='nvim $HOME/.zshrc'
alias tmuxconf='nvim $HOME/.tmux.conf'
# alias tmux-git='tmux new-window -n git \; split-window -h -l 140 \; send-keys -t git.1 "cat ~/.commit_template" C-m'
if [[ $TMUX ]];then
  export FZF_TMUX=1
fi

case ${OSTYPE} in
  darwin*)
    # Add Visual Studio Code (code)
    export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

    export NVM_DIR="$HOME/.nvm"
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc"
    source "/opt/homebrew/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc"
    ;;
  linux*)
    if [ -e /etc/debian_version ]; then
      eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
      [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
      [ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
    elif [ -e /etc/arch-release ]; then
      source /usr/share/nvm/init-nvm.sh
      export NVM_DIR="$HOME/.nvm"
      source /usr/share/nvm/nvm.sh
      source /usr/share/nvm/bash_completion
      source /usr/share/nvm/install-nvm-exec

      source /opt/google-cloud-sdk/completion.zsh.inc
      source /opt/google-cloud-sdk/path.zsh.inc
    fi
    ;;
esac

# alias for terraform
alias tf="terraform"

# Go
export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"

# neovim
export XDG_CONFIG_HOME="$HOME/.config"
export NVIM_CACHE_HOME="$HOME/.vim/bundles"
export EDITOR=nvim
export LANG=ja_JP.UTF-8

# aws completion
complete -C `command -v aws_completer` aws

#yarn
#export PATH="$PATH:/Users/peacock/.anyenv/envs/nodenv/shims/yarn"
#export PATH="$PATH:`yarn global bin`"

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
  print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
  command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
  command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
    print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
    print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
  zinit-zsh/z-a-patch-dl \
  zinit-zsh/z-a-as-monitor \
  zinit-zsh/z-a-bin-gem-node \
  zsh-users/zsh-autosuggestions \
  zsh-users/zsh-completions \
  zdharma/fast-syntax-highlighting \
  zdharma/history-search-multi-word \
  mollifier/anyframe \
  akoenig/npm-run.plugin.zsh \
  srijanshetty/zsh-pip-completion \
  hlissner/zsh-autopair

# zinit ice lucid depth"1" blockf
# zinit light yuki-ycino/fzf-preview.zsh

# bindkey '^i' fzf-or-normal-completion
# bindkey '^v' fzf-grep-vscode
#
# bindkey '^ '   fzf-snippet-selection
# bindkey ' '    fzf-auto-snippet-and-space
# bindkey '^m'   fzf-auto-snippet-and-accept-line
# bindkey '^[f'  fzf-snippet-next-placeholder
# bindkey '^i'   fzf-or-normal-completion
# bindkey '^x^s' fzf-snippet-selection

# export PATH="$(ghq root)/github.com/yuki-yano/fzf-preview-deno.zsh/bin/:$PATH"
# source $(ghq root)/github.com/yuki-yano/fzf-preview-deno.zsh/fzf-preview.zsh
zinit light "yuki-yano/fzf-preview-deno.zsh"

bindkey ' '    fp-auto-snippet
bindkey '^m'   fp-auto-snippet-and-accept-line
bindkey '^x^s' fp-insert-snippet
bindkey '^t'   fp-completion

function ghq-fzf() {
  local selected_dir=$(ghq list | fzf --query="$LBUFFER")

  if [ -n "$selected_dir" ]; then
    BUFFER="cd $(ghq root)/${selected_dir}"
  fi

  zle reset-prompt
}
zle -N ghq-fzf
bindkey "^g" ghq-fzf

function history-fzf () {
  BUFFER=$(history -n 1 | fzf --query="$LBUFFER")
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf

function ssh-fzf () {
  local selected_host=$(grep "Host " ~/.ssh/config | grep -v '*' | cut -b 6- | fzf --query="$LBUFFER")
  if [ -n "$selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N ssh-fzf
bindkey '^\' ssh-fzf

# zinit light "https://gist.github.com/peacock0803sz/2d283b4f3ce74c780aa89b1c18fe08b8"

# theme
zinit load romkatv/powerlevel10k

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

nvm use default --silent

# To customize prompt, run `p10k configure` or edit ~/dotfiles/.p10k.zsh.
[[ ! -f ~/dotfiles/.p10k.zsh ]] || source ~/dotfiles/.p10k.zsh
