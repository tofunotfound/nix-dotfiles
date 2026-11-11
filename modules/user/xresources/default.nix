{ config, lib, ... }:

let
  cfg = config.myHomeModules.xresources;
in

{

  options.myHomeModules.xresources.enable = lib.mkEnableOption "xresources settings";

  options.myHomeModules.xresources.dpi = lib.mkOption
  { type = lib.types.int;
    default = 140;
  };

  config = lib.mkIf cfg.enable
  { xresources.properties =
    { "Xft.dpi" = cfg.dpi;
    };
  };

}
