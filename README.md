# Chiaroscuro

A theme for the [NixOS](https://nixos.org/) desktop environment that works with [Rhodium](https://github.com/pabloagn/rhodium) out of the box.

## Usage

1. Include the theme in your flake:

```nix
inputs = {
  chiaroscuro = {
    url = "github:pabloagn/chiaroscuro";
    inputs.nixpkgs.follows = "nixpkgs";
  };
};
```

2. Build the theme directly:

```sh
nix build
```

## Development Environment

Enter the development environment included in the flake:

```sh
nix develop
```

This will give you a shell with the theme's dependencies and tools available.
