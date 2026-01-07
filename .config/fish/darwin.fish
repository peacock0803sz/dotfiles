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

# {{{ Workaround for GitHub Copilot CLI
alias github-copilot-cli gh-copilot
source "$HOME/.local/share/gh/extensions/gh-fish/gh-copilot-alias.fish"
# }}}

function aibo
    if not set -q NVIM_APPNAME
        set --export NVIM_APPNAME 'nvim.aibo'
    end

    if not set -q argv[1]
        set argv claude
    end
    nvim "+:Aibo $argv[1]"
end

# vim
alias vim@bsd /usr/bin/vim
alias vim@head "$HOME/.nix-profile/bin/vim"

# neovim
set --global --export EDITOR nvim

# man
set --global --export MANPAGER 'nvim -c ASMANPAGER -'

# Language specific settings {{{
# Go
fish_add_path $GOPATH/bin

# Python
set --global --export PIP_REQUIRE_VIRTUALENV 1
# }}}
