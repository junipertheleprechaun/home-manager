{
  config,
  pkgs,
  ...
}: let
  hostMap = import ./host-mapper.nix;
in {
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = hostMap {
      "nas" = {
        hostname = "tart";
        user = "nas-admin";
      };
      "vm.local" = {
        hostname = "localhost";
        user = "user";
        port = 2222;
      };
      "leopard.local" = {
        hostname = "leopard";
        user = "juniper";
      };
      "leopard.remote" = {
        hostname = "leopard-remote";
        port = 22;
        user = "juniper";
      };
      "tart.local" = {
        hostname = "tart";
        user = "juniper";
      };
      "tart.remote" = {
        hostname = "tart-remote";
        port = 22;
        user = "juniper";
      };
      "noduh.mc" = {
        hostname = "mc.noduh.dev";
        port = 1822;
        user = "bob";
      };
      "john.noduh.mc" = {
        hostname = "mc.noduh.dev";
        port = 1822;
        user = "john";
      };
      "leprechaun.mc" = {
        hostname = "mc.leprechaun.dev";
        port = 1722;
        user = "john";
      };
    };
    extraOptionOverrides = {
      EnableEscapeCommandline = "true";
      AddKeysToAgent = "yes";
      ControlMaster = "auto";
      ControlPath = "~/.ssh/control/%h:%r";
      ControlPersist = "10m";
      IdentityAgent = "~/.ssh/ssh_auth_sock";
    };
  };
  home.file.".ssh/control/.keep".text = "can't create a directory without creating a file :/";
}
