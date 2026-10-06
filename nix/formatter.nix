{...}: {
  projectRootFile = "flake.nix";

  programs = {
    alejandra.enable = true; # .nix
    shfmt.enable = true; # .sh
    # jsonfmt.enable = true; # .json, invalid until rendered
  };
}
