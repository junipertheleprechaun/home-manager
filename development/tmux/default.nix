{
  pkgs,
  lib,
  ...
}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    escapeTime = 10;
    baseIndex = 1;
    mouse = false;
    keyMode = "vi";
    sensibleOnTop = true;
    extraConfig = lib.concatMapStringsSep "\n" builtins.readFile [
      ./extra.conf
    ];
    plugins = with pkgs.tmuxPlugins; [
      {
        plugin = minimal-tmux-status;
        extraConfig = builtins.readFile ./status.conf;
      }
    ];
  };
}
