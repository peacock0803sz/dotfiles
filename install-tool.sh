#!/bin/zsh

#zplug
curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

#anyenv
git clone https://github.com/riywo/anyenv ~/.anyenv
source .zshrc
#anyenv plugins
mkdir -p $(anyenv root)/plugins
git clone https://github.com/znz/anyenv-git.git $(anyenv root)/plugins/anyenv-git
git clone https://github.com/znz/anyenv-update.git $(anyenv root)/plugins/anyenv-update
