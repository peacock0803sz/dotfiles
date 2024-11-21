OS := $(shell uname -s)

ifeq ($(OS),Darwin)
	HOST := $(subst .local,,$(shell hostname))
else
	HOST := $(shell uname -n)
endif

.PHONY:
upgrade:
	rm ./flake.lock
	nix run nix-darwin -- switch --flake .#$(HOST) --impure
	git add ./flake.lock
	git commit -m "Update flake.lock for $(HOST)"
