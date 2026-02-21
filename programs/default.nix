{
  pkgs,
  unstable,
  ...
}: {
  imports = [
    ./firefox.nix
    ./obs.nix
    ./krita
  ];
  programs.discord.enable = true;
  home.packages = with pkgs; [
    fluffychat
    unstable.element-desktop
  ];
}
