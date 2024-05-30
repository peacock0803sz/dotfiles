# vim:foldmethod=marker
fish_default_key_bindings
set -U fish_greeting

# OS specific settings {{{
switch (uname -s)
    case Darwin
        set --export --global HOMEBREW_NO_AUTO_UPDATE 1
        alias tailscale "/Applications/Tailscale.app/Contents/MacOS/Tailscale"
        alias rosetta "arch -x86_64 $(which fish)"

        # Homebrew
        switch (uname -m)
            case x86_64
                set --global HOMEBREW_PREFIX /usr/local
            case arm64
                set --global HOMEBREW_PREFIX /opt/homebrew
        end

        eval ($HOMEBREW_PREFIX/bin/brew shellenv)
        set --append --path PATH "$HOMEBREW_PREFIX/sbin"
end
# }}}

set --append --path PATH $HOME/.local/bin
set --append --path PATH $HOME/dotfiles/bin

function mkcd
    mkdir -p $1 && cd $1
end

function fzf-ghq
    set --function _dir $(ghq list -p | fzf --preview 'bat {}/README.md' --bind 'ctrl-d:preview-down,ctrl-u:preview-up')
    commandline "cd $_dir"
end
bind \cg fzf-ghq

### tide prompts {{{
set --global tide_character_icon '$'
set --global tide_character_color green

set --global tide_status_color green
set --global tide_status_color_failure red

set --global tide_pwd_color_anchors blue
set --global tide_pwd_color_dirs blue
set --global tide_pwd_color_truncated_dirs blue

set --global tide_git_color_branch green
set --global tide_git_color_conflicted red
set --global tide_git_color_operation red
set --global tide_git_color_stash green
set --global tide_git_color_dirty yellow
set --global tide_git_color_staged yellow
set --global tide_git_color_untracked blue
set --global tide_git_color_modified yellow

set --global tide_kubectl_color blue
set --global tide_docker_color blue
set --global tide_node_color green
set --global tide_ruby_color red
set --global tide_rust_color yellow
set --global tide_python_color blue
set --global tide_terraform_color blue
#  }}}

# neovim
set --global --export XDG_CONFIG_HOME $HOME/.config
set --global --export EDITOR nvim
set --global --export LANG en_US.UTF-8

# VS Code
switch $OSTYPE
    case darwin
        alias code "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
end

# man
set -xg MANPAGER 'nvim -c ASMANPAGER -'

# Language specific settings {{{
# Java with OpenJDK
switch (uname -s)
    case "Darwin"
        set --append --path PATH "$HOMEBREW_PREFIX/opt/openjdk/bin"
end

# MySQL and PostgreSQL
switch (uname -s)
    case "Darwin"
        set --append --path PATH "$HOMEBREW_PREFIX/opt/mysql-client/bin/"
        set --append --path PATH "$HOMEBREW_PREFIX/opt/libpq/bin"
end

# Go
set --global --export GOPATH $HOME/ghq
set --append --path PATH $GOPATH/bin

# Rust
set --append --path PATH $HOME/.cargo/bin

# Python
set --global --export PIP_REQUIRE_VIRTUALENV 1

# }}}

# Aliases / Abbreviations {{{
abbr --add yq gojq # yq to gojq
abbr --add tf terraform
# }}}
