# dotfiles

Peacock's dotfiles

### Prerequisite

Nix with [determinate systems's installer](https://github.com/DeterminateSystems/nix-installer) (for non-NixOS environments)

```sh
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

## Get Started

### macOS

```sh
make darwin-bootstrap # Do setup
make darwin-upgrade # Upgrade
```

### NixOS

```sh
make nixos-bootstrap # Do setup
make nixos-upgrade # for NixOS
```
