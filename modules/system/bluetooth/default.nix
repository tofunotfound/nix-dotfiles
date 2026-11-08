{ config, lib, ... }:

let
  cfg = config.myModules.bluetooth;
in

{
  
  options.myModules.bluetooth.enable = lib.mkEnableOption "add bluetooth";

  config = lib.mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.FastConnectable = true;
    };
  };

}
