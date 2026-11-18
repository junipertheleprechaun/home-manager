{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # CLI packages
    usbutils
    zip
    unzip
    file
    ssh-import-id
    ffmpeg-full
    dig
    openssl
    jq
    trash-cli
    lsof
  ];
}
