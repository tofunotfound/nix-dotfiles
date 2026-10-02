{ config, lib, pkgs, ... }:

{ 

  options = 
  { myFeatures.network = lib.mkEnableOption "network";
    myFeatures.fstrim = lib.mkEnableOption "fstrim";
    myFeatures.openssh = lib.mkEnableOption "openssh";
  };
  
  config = 
  { networking.networkmanager.enable = config.myFeatures.network;
    services.fstrim.enable = config.myFeatures.fstrim;
    services.openssh.enable = config.myFeatures.fstrim;
  };

}
