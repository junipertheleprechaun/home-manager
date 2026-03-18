let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {system = "x86_64-linux";};
  nur = import sources.nur {
    inherit pkgs;
    nurpkgs = pkgs;
  };
in
  nur
