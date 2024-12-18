OS := $(shell uname -s)

ifeq ($(OS),Darwin)
	HOST := $(subst .local,,$(shell hostname))
	CORES = $(shell sysctl -n hw.ncpu)
else
	HOST := $(shell uname -n)
	CORES = $(shell nproc)
endif

.PHONY:
darwin-upgrade:
	nix flake update
	nix run nix-darwin -- switch --flake .#$(HOST) --impure
	git add ./flake.lock
	git commit -m "Update flake.lock for $(HOST)"
