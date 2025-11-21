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

# {{{ Workaround for GitHub Copilot CLI
alias github-copilot-cli gh-copilot
source "$HOME/.local/share/gh/extensions/gh-fish/gh-copilot-alias.fish"
# }}}

# vim
alias vim@bsd /usr/bin/vim
alias vim@head "$HOME/.nix-profile/bin/vim"
