{
  description = "Chiaroscuro - A Theme Manager for the Rhodium System";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    kanso-nvim = {
      url = "github:webhooked/kanso.nvim";
      flake = false;
    };
  };
  
  outputs = { self, nixpkgs, kanso-nvim, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      
      kansoColors = import ./themes/kanso.nix {
        inherit lib;
        src = kanso-nvim;
      };
      
      ports = import ./ports { inherit lib; };
      
    in
    {
      # Expose object
      themes = {
        kanso-zen = {
          palette = kansoColors.zen;
          kitty = ports.generators.kitty { colors = kansoColors; variant = "zen"; };
          ghostty = ports.generators.ghostty { colors = kansoColors; variant = "zen"; };
          yazi = ports.generators.yazi { colors = kansoColors; variant = "zen"; };
          lualine = ports.generators.lualine { colors = kansoColors; variant = "zen"; };
          nvim = ports.generators.nvim { colors = kansoColors; variant = "zen"; };
        };
        
        kanso-ink = {
          palette = kansoColors.ink;
          kitty = ports.generators.kitty { colors = kansoColors; variant = "ink"; };
          ghostty = ports.generators.ghostty { colors = kansoColors; variant = "ink"; };
          yazi = ports.generators.yazi { colors = kansoColors; variant = "ink"; };
          lualine = ports.generators.lualine { colors = kansoColors; variant = "ink"; };
          nvim = ports.generators.nvim { colors = kansoColors; variant = "ink"; };
        };
        
        kanso-pearl = {
          palette = kansoColors.pearl;
          kitty = ports.generators.kitty { colors = kansoColors; variant = "pearl"; };
          ghostty = ports.generators.ghostty { colors = kansoColors; variant = "pearl"; };
          yazi = ports.generators.yazi { colors = kansoColors; variant = "pearl"; };
          lualine = ports.generators.lualine { colors = kansoColors; variant = "pearl"; };
          nvim = ports.generators.nvim { colors = kansoColors; variant = "pearl"; };
        };
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
