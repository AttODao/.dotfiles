{ pkgs, ... }:

{
  boot.supportedFilesystems = [ "btrfs" ];

  environment.systemPackages = with pkgs; [
    btrfs-progs
  ];

  fileSystems."/mnt/ssd1" = {
    device = "/dev/disk/by-label/ssd1";
    fsType = "btrfs";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
      "compress=zstd"
      "noatime"
      "discard=async"
    ];
  };

  fileSystems."/mnt/hdd1" = {
    device = "/dev/disk/by-label/hdd1";
    fsType = "btrfs";
    options = [
      "nofail"
      "x-systemd.automount"
      "x-systemd.idle-timeout=10min"
      "compress=zstd"
      "noatime"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/ssd1 0755 attodao users -"
    "d /mnt/hdd1 0755 attodao users -"
  ];

  services.btrfs.autoScrub = {
    enable = true;
    fileSystems = [
      "/mnt/ssd1"
      "/mnt/hdd1"
    ];
  };
}
