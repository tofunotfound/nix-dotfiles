{ config, lib, ... }:

let
  cfg = config.myHomeModules.syncthing;
in

{

  options.myHomeModules.syncthing.enable = lib.mkEnableOption "enable syncthing";

  config = lib.mkIf cfg.enable
  { services.syncthing.enable = true;
  };

}
