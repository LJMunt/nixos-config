{ config, pkgs, lib, user, ... }:

{
  networking.hostName = "t480";

  boot.loader.systemd-boot.enable = true;
  boot.loader.timeout = 0;
  boot.loader.systemd-boot.editor = false;
  boot.loader.efi.canTouchEfiVariables = true;

  services.fwupd.enable = true;

  services.upower.enable = true;
  powerManagement.enable = true;
  services.thermald.enable = true;
}
