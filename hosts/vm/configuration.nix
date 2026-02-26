{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  networking.hostName = "vm";

  services.qemuGuest.enable = true;

  services.spice-vdagentd.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 1;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;
}
