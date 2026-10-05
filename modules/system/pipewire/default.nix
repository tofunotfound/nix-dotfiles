{ config, lib, pkgs, ... }:

{

  options.myFeatures.pipewire = lib.mkEnableOption "pipewire";  

  config = lib.mkIf config.myFeatures.pipewire
  { services.pipewire = 
    { enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;  
  };

}
