{
  description = "Chiaroscuro Theme - A sophisticated light/dark theme system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Rust dependencies for the parser
        rustPlatform = pkgs.rustPlatform;

        # Build the parser
        chiaroscuroParser = rustPlatform.buildRustPackage {
          pname = "chiaroscuro-parser";
          version = "0.1.0";

          src = ./parser;

          cargoLock = {
            lockFile = ./parser/Cargo.lock;
          };

          nativeBuildInputs = with pkgs; [ pkg-config ];
        };

        # Function to build theme for specific variant
        buildThemeVariant = variant: pkgs.stdenv.mkDerivation rec {
          pname = "chiaroscuro-theme-${variant}";
          version = "0.1.0";

          src = ./.;

          nativeBuildInputs = with pkgs; [
            sass
            nodePackages.sass
            chiaroscuroParser
          ];

          buildPhase = ''
            # Create output directory
            mkdir -p $out

            # Compile SCSS to CSS with variant-specific variables
            echo "Compiling SCSS for ${variant} variant..."

            # Create a variant-specific SCSS file
            cat > variant.scss << EOF
            \$theme-variant: '${variant}';
            @import 'src/main.scss';
            EOF

            sass variant.scss $out/chiaroscuro.css \
              --style=expanded

            # Parse CSS to generate Nix
            echo "Parsing CSS to Nix..."
            chiaroscuro-parser $out/chiaroscuro.css $out/chiaroscuro.nix

            # Copy wallpapers
            echo "Copying wallpaper collections..."
            if [ -d "assets/wallpapers" ]; then
              cp -r assets/wallpapers $out/wallpapers
            else
              echo "Warning: No wallpapers directory found at assets/wallpapers"
              mkdir -p $out/wallpapers
            fi
          '';

          installPhase = ''
            echo "Theme package created at $out"
          '';
        };

        # Main theme derivation (default to dark)
        chiaroscuroTheme = buildThemeVariant "dark";

      in
      {
        packages = {
          default = chiaroscuroTheme;
          parser = chiaroscuroParser;
          dark = buildThemeVariant "dark";
          light = buildThemeVariant "light";
        };

        # Expose lib functions
        lib = {
          # Generate tokens for a specific variant
          getTokens = variant:
            let
              themePackage = buildThemeVariant variant;
            in
            import "${themePackage}/chiaroscuro.nix";

          # Build theme package for variant
          buildVariant = buildThemeVariant;
        };

        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rustc
            cargo
            rust-analyzer
            sass
            nodePackages.sass
          ];

          shellHook = ''
            echo "Chiaroscuro Theme Development Shell"
            echo "Commands:"
            echo "  nix build         - Build the theme package"
            echo "  nix build .#parser - Build just the parser"
            echo "  cargo run         - Run the parser directly"
          '';
        };
      }) // {
        # System-independent lib
        theme.lib = {
          getTokens = system: variant:
            let
              pkgs = nixpkgs.legacyPackages.${system};
              flakeOutputs = self.outputs.${system} or (throw "Unsupported system: ${system}");
            in
            flakeOutputs.lib.getTokens variant;
        };
      };
}


# {
#   description = "Chiaroscuro Theme - A sophisticated light/dark theme system";

#   inputs = {
#     nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#     flake-utils.url = "github:numtide/flake-utils";
#   };

#   outputs = { self, nixpkgs, flake-utils, ... }:
#     flake-utils.lib.eachDefaultSystem (system:
#       let
#         pkgs = nixpkgs.legacyPackages.${system};

#         # Rust dependencies for the parser
#         rustPlatform = pkgs.rustPlatform;

#         # Build the parser
#         chiaroscuroParser = rustPlatform.buildRustPackage {
#           pname = "chiaroscuro-parser";
#           version = "0.1.0";

#           src = ./parser;

#           cargoLock = {
#             lockFile = ./parser/Cargo.lock;
#           };

#           nativeBuildInputs = with pkgs; [ pkg-config ];
#         };

#         # Main theme derivation
#         chiaroscuroTheme = pkgs.stdenv.mkDerivation rec {
#           pname = "chiaroscuro-theme";
#           version = "0.1.0";

#           src = ./.;

#           nativeBuildInputs = with pkgs; [
#             sass
#             nodePackages.sass
#             chiaroscuroParser
#           ];

#           buildPhase = ''
#                         # Create output directory
#                         mkdir -p $out

#                         # Compile SCSS to CSS
#                         echo "Compiling SCSS..."
#                         sass src/main.scss $out/chiaroscuro.css \
#                           --style=expanded

#                         # Parse CSS to generate Nix
#                         echo "Parsing CSS to Nix..."
#                         chiaroscuro-parser $out/chiaroscuro.css $out/chiaroscuro.nix

#                         # Copy wallpapers
#                         echo "Copying wallpaper collections..."
#                         if [ -d "assets/wallpapers" ]; then
#                           cp -r assets/wallpapers $out/wallpapers
#                         else
#                           echo "Warning: No wallpapers directory found at assets/wallpapers"
#                           mkdir -p $out/wallpapers
#                         fi

#                         # Validate wallpaper structure
#                         echo "Validating wallpaper collections..."
#                         for collection in sisyphus prospero eurydice quixote raskolnikov beatrice siddhartha morpheus prometheus cassandra meursault kurtz gatsby ahab zarathustra; do
#                           if [ -d "$out/wallpapers/$collection" ]; then
#                             count=$(find "$out/wallpapers/$collection" -name "wallpaper-*.jpg" -o -name "wallpaper-*.png" -o -name "wallpaper-*.webp" | wc -l)
#                             echo "  ✓ $collection: $count wallpapers"
#                           else
#                             echo "  ⚠ $collection: missing (creating placeholder)"
#                             mkdir -p "$out/wallpapers/$collection"
#                             # Create a placeholder metadata file
#                             cat > "$out/wallpapers/$collection/metadata.json" << EOF
#             {
#               "collection": "$collection",
#               "status": "placeholder",
#               "message": "Wallpapers for this collection need to be added"
#             }
#             EOF
#                           fi
#                         done
#           '';

#           installPhase = ''
#             # Everything is already in $out from buildPhase
#             echo "Theme package created at $out"
#             echo "Contents:"
#             ls -la $out/
#           '';

#           meta = with pkgs.lib; {
#             description = "Chiaroscuro Theme - Sophisticated color system with curated wallpapers";
#             homepage = "https://github.com/yourusername/chiaroscuro-theme";
#             license = licenses.mit;
#             maintainers = with maintainers; [ ];
#             platforms = platforms.all;
#           };
#         };

#       in
#       {
#         packages = {
#           default = chiaroscuroTheme;
#           parser = chiaroscuroParser;
#         };

#         devShells.default = pkgs.mkShell {
#           buildInputs = with pkgs; [
#             rustc
#             cargo
#             rust-analyzer
#             sass
#             nodePackages.sass
#           ];

#           shellHook = ''
#             echo "Chiaroscuro Theme Development Shell"
#             echo "Commands:"
#             echo "  nix build         - Build the theme package"
#             echo "  nix build .#parser - Build just the parser"
#             echo "  cargo run         - Run the parser directly"
#           '';
#         };
#       });
# }
