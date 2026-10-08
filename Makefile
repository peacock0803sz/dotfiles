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
ifeq ($(HOST),arpeggio)
	git -C $(HOME)/ghq/github.com/groove-x/gx-agent-recipes pull || true

	# root が非公開 flake (gx-nur) を git+ssh で取得できるよう、1Password の SSH エージェントを渡す
	sock="$(HOME)/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"; \
	if [ -S "$$sock" ]; then export SSH_AUTH_SOCK="$$sock"; fi; \
	sudo env SSH_AUTH_SOCK="$$SSH_AUTH_SOCK" nix run nix-darwin -- switch --flake .#$(HOST) --impure --cores $(CORES)
else
	sudo nix run nix-darwin -- switch --flake .#$(HOST) --impure --cores $(CORES)
endif

.PHONY:
nixos-bootstrap:
	echo "Please run 'nixos-generate-config' and 'nixos-rebuild switch' manually"

.PHONY:
nixos-upgrade:
	sudo nixos-rebuild switch --flake .#$(HOST) --impure
