{
  config,
  pkgs,
  ...
}: let
  unstable = import ./unstable.nix;
in {
  home.packages = with pkgs; [
    # GNOME extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
    jdk25

    # Graphical applications
    mumble
    tidal-hifi
    yubioath-flutter
    zoom-us
    gimp
    vlc
    orca-slicer
    super-slicer
    godot_4
    blender
    nomacs
    audacity
    evince
    mumble
    vlc

    # CLI packages
    speedtest-cli
    croc
    s-tui
    stress
    usbutils
    zip
    unzip
    file
    ssh-import-id
    dig
    openssl
    jq
    trash-cli
    rclone
    mitmproxy
    smartmontools
    rar
    htop-vim
    iperf3
    btrfs-progs
    yubikey-manager
    ncdu

    # Other shit
    ntfs3g
    exfatprogs
    iotop
    cadaver

    npins
  ];
  programs.chromium = {
    enable = true;
    package = unstable.chromium;
  };
}
