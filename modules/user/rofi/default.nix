{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules;
in

{

  options.myHomeModules.rofi.enable = lib.mkEnableOption "enable rofi";

  options.myHomeModules.rofi.dpi = lib.mkOption
  { type = lib.types.int;
    default = 200;
  };

  config = lib.mkIf cfg.rofi.enable {
    programs.rofi =
    { enable = true;

      theme = lib.mkIf (!cfg.theme.catppuccin.enable) "${pkgs.rofi}/share/rofi/themes/Arc-Dark";

      settings =
      { dpi = cfg.rofi.dpi;
      };
    };
  };

}
