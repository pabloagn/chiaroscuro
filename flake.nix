{
  description = "Chiaroscuro - A Theme Manager for the Rhodium System";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  
  outputs = { self, nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      lib = nixpkgs.lib;
      
      kansoColors = import ./themes/kanso.nix { inherit lib; };
      
      ports = import ./ports { inherit lib; };
      
    in
    {
      themes = {
        kanso-zen = {
          palette = kansoColors.zen;
          kitty = ports.kitty { colors = kansoColors; variant = "zen"; };
          ghostty = ports.ghostty { colors = kansoColors; variant = "zen"; };
          yazi = ports.yazi { colors = kansoColors; variant = "zen"; };
          lualine = ports.lualine { colors = kansoColors; variant = "zen"; };
          nvim = ports.nvim { colors = kansoColors; variant = "zen"; };
          zellij = ports.zellij { colors = kansoColors; variant = "zen"; };
          zathura = ports.zathura { colors = kansoColors; variant = "zen"; };
        };
        
        kanso-ink = {
          palette = kansoColors.ink;
          kitty = ports.kitty { colors = kansoColors; variant = "ink"; };
          ghostty = ports.ghostty { colors = kansoColors; variant = "ink"; };
          yazi = ports.yazi { colors = kansoColors; variant = "ink"; };
          lualine = ports.lualine { colors = kansoColors; variant = "ink"; };
          nvim = ports.nvim { colors = kansoColors; variant = "ink"; };
          zellij = ports.zellij { colors = kansoColors; variant = "ink"; };
          zathura = ports.zathura { colors = kansoColors; variant = "ink"; };
        };
        
        kanso-pearl = {
          palette = kansoColors.pearl;
          kitty = ports.kitty { colors = kansoColors; variant = "pearl"; };
          ghostty = ports.ghostty { colors = kansoColors; variant = "pearl"; };
          yazi = ports.yazi { colors = kansoColors; variant = "pearl"; };
          lualine = ports.lualine { colors = kansoColors; variant = "pearl"; };
          nvim = ports.nvim { colors = kansoColors; variant = "pearl"; };
          zellij = ports.zellij { colors = kansoColors; variant = "pearl"; };
          zathura = ports.zathura { colors = kansoColors; variant = "pearl"; };
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

