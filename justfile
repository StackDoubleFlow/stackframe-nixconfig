set shell := ["fish", "-c"]

rebuild:
  sudo nixos-rebuild switch --flake ~/.nix-configs &| nom

gc:
  sudo nix-collect-garbage -d
