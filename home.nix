{lib, ...}: {
  imports =
    [
      ./development
      ./programs
      ./pkgs.nix
      ./xdg
      ./games
      ./cli.nix
    ]
    ++ (lib.optional (builtins.pathExists ./local) ./local);

  home.username = "john";
  home.homeDirectory = "/home/john";

  programs.home-manager.enable = false;

  systemd.user.startServices = true;

  nixpkgs.config = {
    allowUnfree = true;
  };

  home.stateVersion = "23.11";
}
