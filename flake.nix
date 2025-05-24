# flake.nix
{
  description = "Chiaroscuro - A theme system for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];
        };

        rustToolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = [ "rust-src" "rust-analyzer" ];
        };

        chiaroscuroParser = pkgs.rustPlatform.buildRustPackage {
          pname = "chiaroscuro-parser";
          version = "0.1.0";
          src = ./parser;

          cargoLock = {
            lockFile = ./parser/Cargo.lock;
          };
        };

        themePackage = pkgs.stdenv.mkDerivation {
          pname = "chiaroscuro-theme";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [
            pkgs.sass
            chiaroscuroParser
          ];

          buildPhase = ''
            runHook preBuild
            mkdir -p $out
            sass src/main.scss $out/chiaroscuro.css --style=expanded
            chiaroscuro-parser $out/chiaroscuro.css $out/chiaroscuro.nix
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            runHook postInstall
          '';
        };

        themeTokens = import "${themePackage}/chiaroscuro.nix";

      in
      {
        packages = {
          default = themePackage;
          theme = themePackage;
          parser = chiaroscuroParser;
        };

        inherit themeTokens;

        devShells.default = pkgs.mkShell {
          name = "chiaroscuro-dev-shell";

          nativeBuildInputs = with pkgs; [
            rustToolchain
            cargo-edit
            cargo-watch
            clippy
            rustfmt
            pkg-config
            openssl
            sass
          ];

          shellHook = ''
            export CARGO_TARGET_DIR="$PWD/target_dev"
          '';
        };
      }
    ) // {
      theme = {
        tokens = builtins.mapAttrs (systemName: systemData: systemData.themeTokens)
          (flake-utils.lib.filterSystem supportedSystems self.outputs);

        lib = {
          getTokens = system:
            (flake-utils.lib.filterSystem [system] self.outputs).${system}.themeTokens;

          getVariant = system: variant:
            let tokens = self.outputs.theme.lib.getTokens system;
            in if variant == "dark" then tokens.theme
               else tokens.theme;
        };
      };

      overlays.default = final: prev: {
        chiaroscuroTheme = self.theme.lib.getTokens final.system;
      };
    };
}
