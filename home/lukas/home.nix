{
  config,
  inputs,
  pkgs,
  ...
}:

let
  powermenu = pkgs.writeShellScriptBin "powermenu" ''
    #!/usr/bin/env zsh

    choice=$(printf " Lock\n Logout\n Reboot\n Shutdown" | wofi --dmenu)

    case "$choice" in
      *Lock) hyprlock ;;
      *Logout) hyprctl dispatch exit ;;
      *Reboot) systemctl reboot ;;
      *Shutdown) systemctl poweroff ;;
    esac
  '';
in
{
  home.username = "lukas";
  home.homeDirectory = "/home/lukas";

  programs.home-manager.enable = true;

  programs.zsh.enable = true;

  programs.zsh = {
    shellAliases = {
      ll = "ls -lah";
      gs = "git status";
      vim = "nvim";
      nrs = "sudo nixos-rebuild switch --flake /etc/nixos#$(hostname)";
      neofetch = "fastfetch";
    };
    initContent = ''
      export EDITOR=nvim
      export TERMINAL=ghostty

      autoload -U colors && colors
      PROMPT="%F{46}%n%f@%F{214}%m%f:%d ~ "
    '';
  };

  programs.git.enable = true;

  home.packages = with pkgs; [
    fastfetch
    neovim
    tree-sitter
    (vimPlugins.nvim-treesitter.withAllGrammars)
    ripgrep
    fd
    jq
    tree
    tealdeer
    bat
    onlyoffice-desktopeditors
    powermenu
    nerd-fonts.jetbrains-mono
    jetbrains-mono
    hyprpaper
    hypridle
    hyprlock
    swww
    nil
    stylua
    gcc
    nixfmt
    unzip
    nextcloud-client
    kdePackages.dolphin
    kdePackages.qt6ct
    kdePackages.qtstyleplugin-kvantum
    discord
    tmux
    btop
    nmap
    cliphist
    bitwarden-cli
    bitwarden-menu
    pinentry-qt
    wtype
    termsonic
  ];

  imports = [
    ./hyprland.nix
    ./zen.nix
  ];

  services.mako = {
    enable = true;
    settings = {
      default-timeout = 4000;
      max-visible = 4;
      anchor = "top-right";
      layer = "overlay";
      width = 380;
      height = 140;
      margin = "12,12";
      border-size = 2;
      border-radius = 10;
      font = "JetBrainsMono 11";
      background-color = "#1a1b26dd";
      text-color = "#c0caf5ff";
      border-color = "#7aa2f7ff";

      sort = "-time";
    };
  };

  xdg.configFile."ghostty/config" = {
    text = ''
      font-family = JetBrainsMono Nerd Font
      font-size = 16

      background-opacity = 0.60
      window-padding-x = 8
      window-padding-y = 6

      cursor-style = block
    '';
    force = true;
  };

  xdg.configFile."hypr/hypridle.conf".text = ''
    general {
      lock_cmd = hyprlock
    }

    listener {
     timeout = 600
     on-timeout = hyprlock
    }
  '';

  xdg.configFile."hypr/hyprlock.conf".text = ''
    general {
      hide_cursor = true
      no_fade_in = true
    }
    background {
      monitor = 
      color = rgba(20,22,30,1.0)
    }

    input-field {
      monitor =
      size = 300, 50
      outline_thickness = 2
      dots_size = 0.2
      dots_spacing = 0.35
      dots_center = true
      fade_on_empty = true
      placeholder_text = <i>password</i>
      position = 0, -80
      halign = center
      valign = center
    }

    label {
      monitor =
      text = $TIME
      font_size = 64
      position = 0, 80
      halign = center
      valign = center 
    }

  '';
  xdg.configFile."waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 26,
      "spacing": 8,
      "margin-top": 8,
      "margin-left": 12,
      "margin-right": 12,

      "modules-left": ["hyprland/workspaces", "hyprland/window"],
      "modules-center": ["clock"],
      "modules-right": ["pulseaudio", "network", "cpu", "memory", "tray"],

      "hyprland/workspaces": {
        "format": "{name}",
        "on-scroll-up": "hyprctl dispatch workspace e+1",
        "on-scroll-down": "hyprctl dispatch workspace e-1"
      },

      "hyprland/window": {
        "format": "{}",
        "max-length": 50,
        "separate-outputs": true
      },

      "clock": {
        "format": "  {:%a %d %b  %H:%M}",
        "tooltip-format": "{:%Y-%m-%d %H:%M:%S}"
      },

      "network": {
        "format-wifi": "  {signalStrength}%",
        "format-ethernet": "󰈀  {ipaddr}",
        "format-disconnected": "󰖪  down",
        "tooltip": true
      },

      "cpu": {
        "format": "  {usage}%",
        "tooltip": false
      },

      "memory": {
        "format": "  {used:0.1f}G",
        "tooltip": false
      },

      "pulseaudio": {
        "format": "  {volume}%",
        "format-muted": "󰝟  muted",
        "scroll-step": 5,
        "on-click": "pavucontrol",
        "tooltip": false
      },

      "tray": {
        "spacing": 8
      }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
      border: none;
      border-radius: 0;
      font-family: "JetBrainsMono Nerd Font", "JetBrains Mono", monospace;
      font-size: 12px;
      min-height: 0;
    }

    window#waybar {
      background: rgba(17, 19, 26, 0.75);
      color: #c0caf5;
    }

    #workspaces, #window, #clock, #network, #cpu, #memory, #pulseaudio, #tray {
      background: rgba(26, 27, 38, 0.85);
      margin: 3px 0;
      padding: 1px 6px;
      border-radius: 999px; /* pill */
    }

    /* Workspaces */
    #workspaces {
      padding: 4px 6px;
    }
    #workspaces button {
      color: #a9b1d6;
      background: transparent;
      padding: 1px 4px;
      margin: 0 1px;
      border-radius: 999px;
    }
    #workspaces button.active {
      color: #1a1b26;
      background: #7aa2f7; /* tokyo night blue */
    }
    #workspaces button.urgent {
      background: #f7768e;
      color: #1a1b26;
    }

    /* Accent the clock a bit */
    #clock {
      color: #7dcfff; /* cyan */
    }

    /* Subtle accents on right side */
    #pulseaudio { color: #bb9af7; } /* violet */
    #network     { color: #7aa2f7; }
    #cpu         { color: #9ece6a; } /* green */
    #memory      { color: #e0af68; } /* amber */

    /* Window title dimmer */
    #window {
      color: #a9b1d6;
    }

    /* Tray icons behave nicer */
    #tray {
      padding: 3px 8px;
    }
  '';

  xdg.configFile."nvim/init.lua".text = ''
        local lazypath = vim.fn.stdpath("data") .. "lazy/lazy.nvim"
        if not vim.loop.fs_stat(lazypath) then
          vim.fn.system({
            "git", "clone", "--filter=blob:none",
    	"https://github.com/folke/lazy.nvim.git",
    	"--branch=stable",
    	lazypath,
          })
        end
        vim.opt.rtp:prepend(lazypath)

        require("lazy").setup({
          { "LazyVim/LazyVim", import = "lazyvim.plugins"},
          { import = "plugins"},
        })

  '';

  xdg.configFile."nvim/lua/plugins/tokyonight.lua".text = ''
      return {
        {
          "folke/tokyonight.nvim",
          lazy = false,
          priority = 1000,
          opts = {
            style = "night",
    	transparent = true,
          },
          config = function(_, opts)
            require("tokyonight").setup(opts)
    	vim.cmd.colorscheme("tokyonight")

    	vim.cmd([[hi Normal guibg=NONE ctermbg=NONE]])
          end,
        },
      }
  '';

  xdg.configFile."nvim/lua/plugins/mason-disable-auto.lua".text = ''
    return {
      { "mason-org/mason-lspconfig.nvim", enabled = false },

       {
         "mason-org/mason.nvim",
         opts = function(_, opts)
           opts = opts or {}
           opts.automatic_installation = false
           return opts
         end,
       },

      {
         "neovim/nvim-lspconfig",
         opts = function(_, opts)
           opts.servers = opts.servers or {}
           opts.servers.nil_ls = { cmd = { "nil" } }
           return opts
         end,
       },
     }
  '';

  xdg.configFile."nvim/lua/plugins/nix-format.lua".text = ''
    return {
      {
          "stevearc/conform.nvim",
          opts = {
              formatters_by_ft = {
                  nix = {"nixfmt"},
                },
              formatters = {
                  nixfmt = {
                      command = "nixfmt",
                    },
                },
            },
        },
      }
  '';

  xdg.configFile."wofi/config".text = ''
    width=520
    height=420
    location=center
    show=drun
  '';

  xdg.configFile."wofi/style.css".text = ''
    window {
      margin: 0px;
      border: 2px solid #7aa2f7;
      border-radius: 12px;
      background-color: alpha(#1a1b26, 0.7);
      font-family: "JetBrainsMono Nerd Font";
      font-size: 14px;
      max-height: 420px
      }

    #input {
      margin: 10px;
      padding: 8px;
      border-radius: 8px;
      border: none;
      background-color: #1f2335;
      color: #c0caf5;
    }

    #inner-box {
      margin: 5px;
      border: none;
      background-color: transparent;
    }

    #scroll {
      margin: 0px;
      border: none;
    }

    #entry {
      padding: 8px;
      margin: 4px;
      border-radius: 8px;
      background-color: transparent;
      color: #c8caf5;
    }

    #entry:selected {
      background-color: #7aa2f7;
      color: #1a1b26;
    }

    #text:selected {
      color: #1a1b26
    }
  '';

  xdg.configFile."bwm/config.ini".text = ''
    [dmenu]
    dmenu_command = wofi --dmenu --prompt Bitwarden --lines 4 -theme bwm -i
    pinentry = pinentry-qt
    title_path = 25

    [dmenu_passphrase]
    obscure = true
    obscure_color = #303030

    [vault]
    server_1 = https://dungeon.sogrim.ch
    email_1 = muntwyler.lukas@musys.io
    twofactor_1 = 0
    type_library = wtype

    session_timeout_min = 720

    autotype_default = {USERNAME}{TAB}{PASSWORD}{ENTER}
  '';

  home.file."wallpapers/wallpaper.jpg" = {
    source = pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/42/wallhaven-428wy4.jpg";
      sha256 = "sha256-wFEgeUQUb5V6RDRd0IkhfHQrmOs8j7KmP2RABb6faKI=";
    };
    force = true;
  };

  home.stateVersion = "25.05";
}
