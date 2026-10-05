{ config, lib, pkgs, ... }:

{ 

  options.myFeatures = 
  { network = lib.mkEnableOption "network";
    fstrim = lib.mkEnableOption "fstrim";
    openssh = lib.mkEnableOption "openssh";
  };
  
  config = 
  { networking.networkmanager.enable = config.myFeatures.network;
    services.fstrim.enable = config.myFeatures.fstrim;
    services.openssh.enable = config.myFeatures.openssh;
  };

}
