{ config, lib, pkgs, ... }:

{ 

  options = 
  { myFeatures.network = lib.mkEnableOption "network";
    myFeatures.fstrim = lib.mkEnableOption "fstrim";
  };
  
  config = 
  { networking.networkmanager.enable = config.myFeatures.network;
    services.fstrim.enable = config.myFeatures.fstrim;
  };

}
