{
  config,
  pkgs,
  ...
}: {
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
  };
  programs.bash = {
    enable = true;
    bashrcExtra = builtins.readFile ./bashrc-extra.sh;
    shellAliases = {
      "rm" = "trash";
      "ls" = "ls --color";
    };
    historyControl = ["ignoreboth"];
  };

  home.packages = with pkgs; [
    trash-cli
  ];
  home.sessionVariables = {
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };
}
