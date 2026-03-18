{...}: let
  nur = import ../nur.nix;
  unstable = import ../unstable.nix;
in {
  programs.firefox = {
    enable = true;
    package = unstable.firefox;
    profiles.john = {
      extensions.packages = with nur.repos.rycee.firefox-addons; [
        bitwarden
      ];
    };
  };
}
