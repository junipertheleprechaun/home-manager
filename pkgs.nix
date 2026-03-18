{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # GNOME extensions
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator

    # Graphical applications
    mumble
    tidal-hifi
    yubioath-flutter
    zoom-us
    gimp
    chromium
    vlc
    orca-slicer
    super-slicer
    godot_4
    blender
    nomacs
    audacity
    evince
    mumble

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
    binutils
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
  programs.chromium.enable = true;
}
