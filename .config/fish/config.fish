# vim:foldmethod=marker
fish_default_key_bindings
set -U fish_greeting

# OS specific settings {{{
switch (uname -s)
    case Darwin
        set --global --export XDG_CONFIG_HOME $HOME/.config
        set --export --global HOMEBREW_NO_AUTO_UPDATE 1
        alias tailscale "/Applications/Tailscale.app/Contents/MacOS/Tailscale"
        # alias rosetta "arch -x86_64 $(which fish)"

        # Homebrew
        switch (uname -m)
            case x86_64
                set --export --global HOMEBREW_PREFIX /usr/local
            case arm64
                set --export --global HOMEBREW_PREFIX /opt/homebrew
        end

        eval ($HOMEBREW_PREFIX/bin/brew shellenv)
        fish_add_path "$HOMEBREW_PREFIX/sbin"
        source "$HOME/.config/op/plugins.sh"
end
# }}}

if test $(uname -n) = 'arpeggio.local'
    source $HOME/dotfiles/.config/fish/work.fish
end

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
    set --function _dir $(gwq list --global --json | jq -r ".[].path" | fzf --preview 'bat {}/README.md' --bind 'ctrl-d:preview-down,ctrl-u:preview-up')
    commandline "cd $_dir"
end
bind \cG fzf-gwq

### tide prompts {{{
set --universal tide_character_icon '$'
set --universal tide_character_color green

set --universal tide_status_color green
set --universal tide_status_color_failure red

set --universal tide_pwd_color_anchors blue
set --universal tide_pwd_color_dirs blue
set --universal tide_pwd_color_truncated_dirs blue

set --universal tide_git_color_branch green
set --universal tide_git_color_conflicted red
set --universal tide_git_color_operation red
set --universal tide_git_color_stash green
set --universal tide_git_color_dirty yellow
set --universal tide_git_color_staged yellow
set --universal tide_git_color_untracked blue
set --universal tide_git_color_modified yellow

set --universal tide_right_prompt_items status context jobs direnv node python rustc java php pulumi ruby go gcloud terraform aws nix_shell crystal elixir zig
set --universal tide_kubectl_color blue
set --universal tide_docker_color blue
set --universal tide_node_color green
set --universal tide_ruby_color red
set --universal tide_rust_color yellow
set --universal tide_python_color blue
set --universal tide_terraform_color blue
#  }}}

# vim
alias vim@bsd /usr/bin/vim
alias vim@head "$HOME/.nix-profile/bin/vim"
alias vim vim@head

# neovim
set --global --export EDITOR nvim
set --global --export LANG en_US.UTF-8

# man
set --global --export MANPAGER 'nvim -c ASMANPAGER -'

# devenv
direnv hook fish | source

# Language specific settings {{{
# Go
set --append --export --global GOPATH $HOME/ghq
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

# {{{ Workaround for GitHub Copilot CLI
alias github-copilot-cli gh-copilot
source "$HOME/.local/share/gh/extensions/gh-fish/gh-copilot-alias.fish"
# }}}

# Aliases / Abbreviations {{{
alias git-root "git rev-parse --show-toplevel"
alias docker podman
abbr --add yq gojq # yq to gojq
abbr --add tf terraform
abbr --add zenn "bunx zenn-cli@latest"
# }}}
