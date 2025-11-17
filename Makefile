OS := $(shell uname -s)

ifeq ($(OS),Darwin)
	HOST := $(subst .local,,$(shell hostname))
	CORES = $(shell sysctl -n hw.ncpu)
else
	HOST := $(shell uname -n)
	CORES = $(shell nproc)
endif

.PHONY:
darwin-bootstrap:
	sudo nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake .#$(HOST) --impure --cores $(CORES)

.PHONY:
darwin-upgrade:
	sudo nix run nix-darwin -- switch --flake .#$(HOST) --impure --cores $(CORES)

.PHONY:
nixos-bootstrap:
	echo "Please run 'nixos-generate-config' and 'nixos-rebuild switch' manually"

.PHONY:
nixos-upgrade:
	sudo nixos-rebuild switch --flake .#$(HOST) --impure

.PHONY:
.ONESHELL:
node2nix-upgrade:
	cd ./.config/nix/hosts/$(HOST)/node2nix && nix-shell -p nodePackages.node2nix --command 'node2nix -i ./node-packages.json -o node-packages.nix'
