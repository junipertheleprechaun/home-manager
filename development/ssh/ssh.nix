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
      "jimbaloothy" = {
        hostname = "bastion.zyte.space";
        "user" = "admin";
        port = 2322;
      };
      "vm.local" = {
        hostname = "localhost";
        user = "user";
        port = 2222;
      };
      "leopard.steam" = {
        hostname = "leopard.lan";
        user = "steam";
      };
      "leopard.local" = {
        hostname = "leopard.lan";
        user = "juniper";
      };
      "leopard.remote" = {
        hostname = "leopard-remote";
        port = 22;
        user = "juniper";
      };
      "tart.local" = {
        hostname = "tart.lan";
        user = "juniper";
      };
      "tart.remote" = {
        hostname = "tart.van-pogona.ts.net";
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
      ControlMaster = "auto";
      ControlPath = "~/.ssh/control/%h:%r";
      ControlPersist = "10m";
    };
  };
  home.file.".ssh/control/.keep".text = "can't create a directory without creating a file :/";
}
