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
	nix --extra-experimental-features 'nix-command flakes' run nix-darwin/master#darwin-rebuild -- switch --flake .#$(HOST) --impure --cores $(CORES)

.PHONY:
darwin-upgrade:
	nix flake update
	nix run nix-darwin -- switch --flake .#$(HOST) --impure --cores $(CORES)
	git add ./flake.lock
	git commit -m "Update flake.lock"

.PHONY:
nixos-bootstrap:
	echo "Please run 'nixos-generate-config' and 'nixos-rebuild switch' manually"

.PHONY:
nixos-upgrade:
	nix flake update
	sudo nixos-rebuild switch --flake .#$(HOST) --impure
	git add ./flake.lock
	git commit -m "Update flake.lock"
