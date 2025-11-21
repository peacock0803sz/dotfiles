# vim:foldmethod=marker
fish_default_key_bindings
set -U fish_greeting

# Host/OS specific settings {{{
switch (uname -s)
    case Darwin
        source $HOME/dotfiles/.config/fish/darwin.fish
        if test $(uname -n) = 'arpeggio.local'
            source $HOME/dotfiles/.config/fish/work.fish
        end
end
# }}}

fish_add_path $HOME/.local/bin
fish_add_path $HOME/dotfiles/bin

function mkcd
    mkdir -p $argv[1] && cd $argv[1]
end

function fzf-ghq
    set --function _dir $(ghq list -p | fzf --preview 'bat {}/README.md' --bind 'ctrl-d:preview-down,ctrl-u:preview-up')
    commandline "cd $_dir"
end
bind \cg fzf-ghq

function fzf-gwq
    set --function _dir $(gwq list --json | jq -r ".[].path" | fzf --preview 'bat {}/README.md' --bind 'ctrl-d:preview-down,ctrl-u:preview-up')
    commandline "cd $_dir"
end
bind \ct fzf-gwq

# tide prompts
source $HOME/dotfiles/.config/fish/tide.fish

# devenv
direnv hook fish | source

# neovim
set --global --export EDITOR nvim
set --global --export LANG en_US.UTF-8

# man
set --global --export MANPAGER 'nvim -c ASMANPAGER -'

# Language specific settings {{{
# Go
fish_add_path $GOPATH/bin

# Python
set --global --export PIP_REQUIRE_VIRTUALENV 1
# }}}

# https://github.com/yuki-yano/zeno.zsh {{{
# set --global --export ZENO_ROOT $HOME/.local/share/fish/plugins/zeno.zsh
# if test "$ZENO_LOADED" = 1
#     bind ' ' zeno-auto-snippet
#     bind \r zeno-auto-snippet-and-accept-line
#     bind \t zeno-completion
#     bind \cx\x20 zeno-insert-space
# end
# }}}

# Aliases / Abbreviations {{{
alias git-root "git rev-parse --show-toplevel"
abbr --add yq gojq # yq to gojq
abbr --add tf terraform
# }}}
