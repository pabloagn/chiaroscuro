{
  description = "Chiaroscuro - A Theme Manager for the Rhodium System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Theme sources
    kanso-nvim = {
      url = "github:webhooked/kanso.nvim";
      flake = false;
    };

    # tokyonight-nvim = {
    #   url = "github:folke/tokyonight.nvim";
    #   flake = false;
    # };
  };

  outputs = 
    { self
    , nixpkgs
    , kanso-nvim
    # , tokyonight-nvim
    , ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
    in
    {
      colors = {
        kanso = import ./themes/kanso.nix {
          inherit lib;
          src = kanso-nvim;
        };
      };
      
      generators = {
        nvim = import ./ports/nvim.nix { inherit lib; };
        ghostty = import ./ports/ghostty.nix { inherit lib; };
        kitty = import ./ports/kitty.nix { inherit lib; };
        lualine = import ./ports/lualine.nix { inherit lib; };
        yazi = import ./ports/yazi.nix { inherit lib; };
        # alacritty = import ./ports/alacritty.nix { inherit lib; };
        # wezterm = import ./ports/wezterm.nix { inherit lib; };
        # foot = import ./ports/foot.nix { inherit lib; };
      };
      
      # Dev shell
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixpkgs-fmt
          nil
          git
          lua
        ];
      };
    };
}

