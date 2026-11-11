{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.rofi;
in

{

  options.myHomeModules.rofi.enable = lib.mkEnableOption "enable rofi";

  options.myHomeModules.rofi.dpi = lib.mkOption
  { type = lib.types.int;
    default = 200;
  };

  config = lib.mkIf cfg.enable {
    programs.rofi =
    { enable = true;

      #theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark";

      extraConfig =
      { dpi = cfg.dpi;
      };
    };
  };

}
