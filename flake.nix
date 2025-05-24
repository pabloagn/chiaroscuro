# flake.nix

{
  description = "Flake for Chiaroscuro";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Build the parser tool
        parser = pkgs.rustPlatform.buildRustPackage {
          pname = "parser";
          version = "0.1.0";
          src = ./parser;

          cargoLock = {
            lockFile = ./parser/Cargo.lock;
          };
        };

      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            sass
            rustc
            cargo
            # Optional: for debugging
            rustfmt
            clippy
          ];
        };

        packages = {
          # Export the parser tool separately if needed
          inherit parser;

          # The main chiaroscuro package
          chiaroscuro = pkgs.stdenv.mkDerivation {
            pname = "chiaroscuro";
            version = "0.1.0";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              sass
              parser
            ];

            buildPhase = ''
              runHook preBuild

              # Create output directory
              mkdir -p dist

              # Step 1: Compile SCSS to CSS
              echo "Compiling SCSS to dist/chiaroscuro.css..."
              sass src/main.scss dist/chiaroscuro.css --style=expanded

              # Step 2: Generate Nix file from CSS
              echo "Generating Nix tokens to dist/chiaroscuro.nix..."
              parser dist/chiaroscuro.css dist/chiaroscuro.nix

              runHook postBuild
            '';

            installPhase = ''
              runHook preInstall
              mkdir -p $out
              cp -r dist/* $out/
              runHook postInstall
            '';
          };

          default = self.packages.${system}.chiaroscuro;
        };
      });
}
