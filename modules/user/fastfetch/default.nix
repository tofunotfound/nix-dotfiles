{ config, lib, ... }:

let
  cfg = config.myHomeModules.fastfetch;
in

{

  options.myHomeModules.fastfetch.enable = lib.mkEnableOption "enable fastfetch";

  config = lib.mkIf cfg.enable
  { programs.fastfetch =
    { enable = true;

      settings =
      { logo =
        { source = "none";
          padding.right = 1;
        };

        modules =
        [ #"title"
          #"separator"
          "os"
          "host"
          "kernel"
          "uptime"
          "packages"
          "shell"
          "display"
          "wm"
          "wmtheme"
          #"theme"
          #"icons"
          "font"
          #"cursor"
          "terminal"
          "terminalfont"
          "cpu"
          "gpu"
          "memory"
          "swap"
          "disk"
          #"localip"
          "battery"
          "poweradapter"
          #"locale"
          #"break"
          #"colors"
        ];
      };
    };
  };

}
