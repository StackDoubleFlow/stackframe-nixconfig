set shell := ["fish", "-c"]

rebuild:
  sudo nixos-rebuild switch --flake ~/.nix-configs &| nom

rebuild-local:
  sudo nixos-rebuild switch --flake ~/.nix-configs --builders '' &| nom

gc:
  sudo nix-collect-garbage -d
