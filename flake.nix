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
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.sass
          ];
        };

        packages.chiaroscuro = pkgs.stdenv.mkDerivation {
          pname = "chiaroscuro";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ pkgs.sass ];

          buildPhase = ''
            runHook preBuild
            mkdir -p $out/dist
            sass src/main.scss $out/dist/chiaroscuro.css --style=expanded
            runHook postBuild
          '';

          installPhase = ''
            runHook preInstall
            runHook postInstall
          '';
        };

        packages.default = self.packages.${system}.chiaroscuro;
      });
}
