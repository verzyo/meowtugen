{
  inputs = {
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      flake = false;
    };

    treefmt = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {
    treefmt,
    nixpkgs,
    self,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {inherit system;};

    treefmtEval = treefmt.lib.evalModule pkgs {
      imports = [./nix/formatter.nix];
    };
  in {
    homeModules = rec {
      meowtugen = import ./nix/home.nix {inherit (inputs) dms;};
      default = meowtugen;
    };

    formatter.${system} = treefmtEval.config.build.wrapper;
  };
}
