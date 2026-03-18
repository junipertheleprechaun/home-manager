let
  sources = import ./npins;
  unstable = import sources.unstable {system = "x86_64-linux";};
in
  unstable
