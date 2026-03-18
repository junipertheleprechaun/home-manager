let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {system = "x86_64-linux";};
  hmLib = (import sources.home-manager).lib {inherit (pkgs) lib;};
in
  hmLib.homeManagerConfiguration {
    inherit pkgs;
    modules = [
      ./home.nix
    ];
  }
