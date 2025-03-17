set shell := ["fish", "-c"]

rebuild:
  sudo nixos-rebuild switch --flake ~/.nix-configs --max-jobs 0 &| nom

gc:
  sudo nix-collect-garbage -d
