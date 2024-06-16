set shell := ["fish", "-c"]

rebuild:
  sudo nixos-rebuild switch --flake ~/.nix-configs &| nom
