{ config, lib, ... }:

let
  cfg = config.myHomeModules.xresources;
in

{

  options.myHomeModules.xresources.enable = lib.mkEnableOption "xresources settings";

  config = lib.mkIf cfg.enable {
    xresources.properties = 
    { "Xft.dpi" = 140;
    };
  };

}
