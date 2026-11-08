{ config, lib, ... }:

let
  cfg = config.myModules;
in

{ 

  options.myModules = 
  { networkmanager.enable = lib.mkEnableOption "add NM";
    fstrim.enable = lib.mkEnableOption "add fstrim";
    zram.enable = lib.mkEnableOption "add zram";
  };

  config =
  { networking.networkmanager.enable = cfg.networkmanager.enable;
    services.fstrim.enable = cfg.fstrim.enable;
    zramSwap.enable = cfg.zram.enable;
  };

}
