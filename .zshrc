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

# Use modern completion system
autoload -Uz promptinit
# compinit

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
zstyle ':completion:*:sudo:*' command-path /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# PROMPT=%#
# RPROMPT=[%?]

mkcd() {
    mkdir -p $1
    cd $1
}

# aliases

alias reloadzsh='exec -l zsh'
alias acvenv='source venv/bin/activate'
alias nvimconf='nvim $HOME/.config/nvim/init.vim'
alias zshconf='nvim $HOME/.zshrc'
alias tmuxconf='nvim $HOME/.tmux.conf'
if [[ $TMUX ]];then
  export FZF_TMUX=1
fi


# Go
export GOPATH=~/go
export PATH="$PATH:$GOPATH/bin"

# anyenv
# export PATH="$HOME/.anyenv/bin:$PATH"
# eval "$(anyenv init - zsh)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

ghq-fzf() {
    local selected_dir=$(ghq list | fzf-tmux --query="$LBUFFER")

    if [ -n "$selected_dir" ]; then
        BUFFER="cd $(ghq root)/${selected_dir}"
    fi

    zle reset-prompt
}

zle -N ghq-fzf
bindkey "^g" ghq-fzf
function history-fzf() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | eval $tac | fzf-tmux --query "$LBUFFER")
    CURSOR=$#BUFFER
zle reset-prompt
}
zle -N history-fzf
bindkey '^r' history-fzf
function ssh-fzf () {
    local selected_host=$(grep "Host " ~/.ssh/config | grep -v '*' | cut -b 6- | fzf-tmux --query "$LBUFFER")
    if [ -n "$selected_host" ]; then
        BUFFER="ssh ${selected_host}"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N ssh-fzf
bindkey '^\' ssh-fzf
function git-branch-fzf() {
    local selected_branch=$(git for-each-ref --format='%(refname)' --sort=-committerdate refs/heads | perl -pne 's{^refs/heads/}{}' | fzf-tmux --query "$LBUFFER")
    if [ -n "$selected_branch" ]; then
        BUFFER="git switch ${selected_branch}"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N git-branch-fzf
bindkey "^b" git-branch-fzf
function tree-fzf() {
    local SELECTED_FILE=$(tree --charset=o -f | fzf-tmux --query "$LBUFFER" | tr -d '\||`|-' | xargs echo)
    if [ "$SELECTED_FILE" != "" ]; then
        BUFFER="$EDITOR $SELECTED_FILE"
        zle accept-line
    fi
    zle reset-prompt
}
zle -N tree-fzf
bindkey "^t" tree-fzf

# neovim
export XDG_CONFIG_HOME="$HOME/.config"
export NVIM_CACHE_HOME="$HOME/.vim/bundles"
export EDITOR=nvim
export LANG=ja_JP.UTF-8

# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

#yarn
# export PATH="$PATH:/Users/peacock/.anyenv/envs/nodenv/shims/yarn"
# export PATH="$PATH:`yarn global bin`"

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
    zinit-zsh/z-a-meta-plugins \
    zsh-users/zsh-autosuggestions \
    zsh-users/zsh-completions \
    zdharma/fast-syntax-highlighting \
    zdharma/history-search-multi-word \
    eastokes/aws-plugin-zsh \
    chr-fritz/docker-completion.zshplugin \
    akoenig/npm-run.plugin.zsh \
    srijanshetty/zsh-pip-completion \
    hlissner/zsh-autopair

zinit ice lucid depth"1" blockf
zinit light yuki-ycino/fzf-preview.zsh
# source $(ghq root)/github.com/yuki-ycino/fzf-preview.zsh/fzf-preview.zsh

bindkey '^i' fzf-or-normal-completion
bindkey '^v' fzf-grep-vscode
bindkey '^ '   fzf-snippet-selection
bindkey ' '    fzf-auto-snippet-and-space
bindkey '^m'   fzf-auto-snippet-and-accept-line
bindkey '^[f'  fzf-snippet-next-placeholder
bindkey '^i'   fzf-or-normal-completion
bindkey '^x^s' fzf-snippet-selection

zinit load romkatv/powerlevel10k

### End of Zinit's installer chunk

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
