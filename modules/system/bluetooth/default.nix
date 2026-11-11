{ config, lib, ... }:

let
  cfg = config.myModules.bluetooth;
in

{

  options.myModules.bluetooth.enable = lib.mkEnableOption "enable bluetooth";

  config = lib.mkIf cfg.enable
  { hardware.bluetooth =
    { enable = true;
    };
  };

}
