{
  config,
  pkgs,
  lib,
  user,
  ...
}:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  time.timeZone = "Europe/Zurich";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    jack.enable = false;
  };
  services.pulseaudio.enable = false;

  services.dbus.enable = true;
  security.polkit.enable = true;
  security.pam.services.hyprlock = { };

  programs.hyprland.enable = true;

  programs.zsh.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  environment.systemPackages = with pkgs; [
    ghostty
    waybar
    wofi
    grim
    slurp
    wl-clipboard
    mako
    brightnessctl
    playerctl
    pavucontrol
    libnotify
  ];

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.hyprland}/bin/start-hyprland";
        user = user;
      };

      # Autologin straight into Hyprland
      initial_session = {
        command = "${pkgs.hyprland}/bin/start-hyprland";
        user = user;
      };
    };
  };

  services.greetd.restart = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
  };

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
    ];
    shell = pkgs.zsh;
  };

  security.sudo.wheelNeedsPassword = true;

  system.stateVersion = "25.05"; # keep consistent once chosen
}
