{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.gtk;
in

{

  options.myHomeModules.gtk.enable = lib.mkEnableOption "enable file settings gtk";

  config = lib.mkIf cfg.enable
  { gtk =
    { enable = true;
      theme =
      { name = "catppuccin-mocha-mauve-standard";
        package = pkgs.catppuccin-gtk.override
        { accents = [ "mauve" ];
          size = "standard";
          variant = "mocha";
        };
      };
    };

    dconf.enable = false;
    services.xsettingsd.enable = true;
    home.sessionVariables = 
    { GTK_THEME = "catppuccin-mocha-mauve-standard";
    };

  };

}
