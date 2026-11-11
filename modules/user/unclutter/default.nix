{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.unclutter;
in

{

  options.myHomeModules.unclutter.enable = lib.mkEnableOption "enable unclutter";

  config = lib.mkIf cfg.enable
  { services.unclutter =
    { enable = true;
      package = pkgs.unclutter-xfixes;
      timeout = 1;
      extraOptions =
      [ "root"
        "jitter 8"
      ];
    };
  };

}
