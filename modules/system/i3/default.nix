{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.xserveri3;
in

{

  options.myModules.xserveri3.enable = lib.mkEnableOption "enable xserver with i3";

  config = lib.mkIf cfg.enable
  { services =
    { displayManager.ly.enable = true;

      xserver =
      { enable = true;
        excludePackages = [ pkgs.xterm ];

        displayManager.sessionCommands =
        ''${pkgs.snixembed}/bin/snixembed -- fork
        '';

        xkb =
        { layout = "ru";
          variant = "";
        };

        windowManager.i3 =
        { enable = true;
          extraPackages = [ pkgs.xclip ];
        };
      };
    };
  };

}
