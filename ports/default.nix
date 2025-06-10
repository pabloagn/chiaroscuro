{ lib }:

{
  ghostty = import ./ghostty.nix { inherit lib; };
  kitty = import ./kitty.nix { inherit lib; };
  lualine = import ./lualine.nix { inherit lib; };
  nvim = import ./nvim.nix { inherit lib; };
  zathura = import ./zathura.nix { inherit lib; };
  zellij = import ./zellij.nix { inherit lib; };
  yazi = import ./yazi.nix { inherit lib; };
}

