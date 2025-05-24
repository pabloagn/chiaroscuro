# flake.nix

{
  description = "Chiaroscuro - A theme system for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    let
      # Generate theme data at evaluation time
      themeData = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          # Build the theme package
          themePackage = pkgs.stdenv.mkDerivation {
            pname = "chiaroscuro-theme";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              sass
              (pkgs.rustPlatform.buildRustPackage {
                pname = "parser";
                version = "0.1.0";
                src = ./parser;
                cargoLock = {
                  lockFile = ./parser/Cargo.lock;
                };
              })
            ];

            buildPhase = ''
              mkdir -p $out

              # Compile SCSS to CSS
              echo "Compiling SCSS..."
              sass src/main.scss $out/chiaroscuro.css --style=expanded

              # Generate Nix tokens
              echo "Generating Nix tokens..."
              parser $out/chiaroscuro.css $out/theme.nix
            '';

            installPhase = ''
              # Already installed in buildPhase
              true
            '';
          };

          # Import the generated theme data (Import From Derivation)
          themeTokens = import "${themePackage}/theme.nix";
        in
        {
          # Expose the raw theme tokens
          inherit themeTokens;

          # Expose the built package
          packages = {
            default = themePackage;
            theme = themePackage;
          };
        }
      );
    in
    themeData // {
      # Expose theme data at the flake level for easier access
      theme = {
        # Extract the tokens for each system
        tokens = builtins.mapAttrs (system: data: data.themeTokens) themeData;

        # Provide a system-agnostic interface
        lib = {
          # Helper to get tokens for a specific system
          getTokens = system: themeData.${system}.themeTokens;

          # Helper to get theme variants
          getVariant = system: variant:
            let tokens = themeData.${system}.themeTokens;
            in if variant == "dark" then tokens.theme
               else tokens.theme; # For now, both map to the same until we add light variant
        };
      };

      # Expose overlays for packages that want to use the theme
      overlays.default = final: prev: {
        chiaroscuroTheme = self.theme.lib.getTokens final.system;
      };
    };
}
