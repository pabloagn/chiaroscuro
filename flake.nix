# phantom-theme/flake.nix
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
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.sass
            pkgs.gawk
            pkgs.gnugrep
            pkgs.gnused
          ];
        };

        packages.phantom-provider = pkgs.stdenv.mkDerivation {
          pname = "phantom-provider";
          version = "0.1.0";
          src = ./.;

          nativeBuildInputs = [
            pkgs.sass
            pkgs.gawk
            pkgs.gnugrep
            pkgs.coreutils
          ];

          buildPhase = ''
            runHook preBuild

            mkdir -p dist

            echo "Compiling SCSS to dist/chiaroscuro.css..."
            sass src/main.scss dist/chiaroscuro.css --style=expanded

            echo "Generating Nix tokens to dist/chiaroscuro.nix..."
            chmod +x scripts/generate-nix-tokens.sh
            ./scripts/generate-nix-tokens.sh dist/chiaroscuro.css dist/chiaroscuro.nix

            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            # Copy the entire dist directory to $out
            mkdir -p $out
            cp -r dist/* $out/
            runHook postInstall
          '';
        };

        packages.default = self.packages.${system}.chiaroscuro;
      });
}
