OS := $(shell uname -s)

ifeq ($(OS),Darwin)
	NIX_JOB := nix run nix-darwin -- switch --flake .#darwin --impure
else
	NIX_JOB := error "Unsupported OS"
endif

.PHONY:
upgrade:
	rm ./flake.lock
	nix run nix-darwin -- switch --flake .#darwin --impure
	git add ./flake.lock
	git commit -m "Update flake.lock for $(OS)"
