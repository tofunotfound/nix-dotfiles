{ config, lib, ... }:

let
  cfg = config.myModules;
in

{ 

  options.myModules = 
  { networkmanager.enable = lib.mkEnableOption "enable nerworkmanager";
    fstrim.enable = lib.mkEnableOption "enable fstrim";
    zram.enable = lib.mkEnableOption "enable zram";
  };

  config =
  { networking.networkmanager.enable = cfg.networkmanager.enable;
    services.fstrim.enable = cfg.fstrim.enable;
    zramSwap.enable = cfg.zram.enable;
  };
 
}
