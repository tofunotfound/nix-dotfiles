{ config, lib, ... }:

let
  cfg = config.myHomeModules.syncthing;
in

{

  options.myHomeModules.syncthing.enable = lib.mkEnableOption "add syncthing";

  config = lib.mkIf cfg.enable {
    services.syncthing.enable = true;
  };

}
