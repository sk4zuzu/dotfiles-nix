SELF := $(patsubst %/,%,$(dir $(abspath $(firstword $(MAKEFILE_LIST)))))

.PHONY: all

all:
	cd $(SELF) && make "$$(hostname -s)"

.PHONY: repti x1a1

repti:
	cd $(SELF) && doas chown -R root:wheel /etc/nixos/
	cd $(SELF) && doas chmod -R ug+rwX,o= /etc/nixos/
	cd $(SELF) && doas nixos-rebuild switch --flake '.#$@' --impure

x1a1:
	cd $(SELF) && doas nixos-rebuild switch --flake '.#$@' --impure

.PHONY: u update

u update:
	nix flake update

.PHONY: c clean

c clean:
	doas nix-collect-garbage -d

.PHONY: o optimise

o optimise:
	nix-store --optimise
