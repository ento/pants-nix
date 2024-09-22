{
  description = "Nix package for Pantsbuild: The ergonomic build system";

  inputs = {
    systems.url = "github:nix-systems/default-linux";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.systems.follows = "systems";
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-23.11";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [rust-overlay.overlays.default];
        };
        pants-bin = pkgs.callPackage ./. {};
      in {
        packages = pants-bin;
        devShells.default = pkgs.mkShell {
          packages = [pants-bin."release_2.20.0"];
        };
      }
    );
}
