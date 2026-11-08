{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.rofi;
in

{

  options.myHomeModules.rofi.enable = lib.mkEnableOption "add rofi";

  config = lib.mkIf cfg.enable {
    programs.rofi = 
    { enable = true;
  
      theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark";
      
      extraConfig = 
      { dpi = 200;
      };
    };
  };

}
