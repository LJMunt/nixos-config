{
  config,
  pkgs,
  lib,
  ...
}:

let
  hyprlockCmd = "${pkgs.hyprlock}/bin/hyprlock";
in
{
  xdg.configFile."hypr/hyprland.conf".text = ''
    # Basic sane defaults
    monitor=,preferred,auto,1

    input {
      kb_layout=ch
      kb_variant=de
      follow_mouse=1
    }

    general {
      gaps_in=3
      gaps_out=5
      border_size=2
      col.active_border = rgba(33ccffee) rgba(ff4499ee) 45deg
      col.inactive_border = rgba(595959aa)
    }

    decoration {
        blur {
            enabled = true
            size = 6
            passes = 2
            new_optimizations = true
          }
        shadow {
            enabled = true
            range = 6
          }
      }

    misc {
      disable_hyprland_logo=true
    }

    # Example: start waybar + notifications
    exec-once = ${pkgs.waybar}/bin/waybar
    exec-once = ${pkgs.mako}/bin/mako
    exec-once = ${pkgs.hypridle}/bin/hypridle
    exec-once = swww-daemon
    exec-once = swww img $HOME/wallpapers/wallpaper.jpg --transition-type simple --transition-duration 1

    # Launcher
    bind = SUPER, R, exec, ${pkgs.wofi}/bin/wofi --show drun --allow-images --layer top

    # Terminal
    bind = SUPER, Q, exec, ${pkgs.ghostty}/bin/ghostty

    bind = SUPER, C, killactive

    # Screenshot
    bind = SUPER, S, exec, ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy

    # Move focus
    bind = SUPER, left, movefocus, l
    bind = SUPER, right, movefocus, r
    bind = SUPER, up, movefocus, u
    bind = SUPER, down, movefocus, d

    # Lock (manual)
    bind = SUPER, L, exec, ${hyprlockCmd}

    bind = SUPER, B, exec, zen

    # Exit Hyprland (careful)
    bind = SUPER, M, exit,
  '';

}
