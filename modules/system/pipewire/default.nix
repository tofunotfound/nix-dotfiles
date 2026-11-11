{ config, lib, ... }:

let
  cfg = config.myModules.pipewire;
in

{

  options.myModules.pipewire.enable = lib.mkEnableOption "enable pipewire";

  config = lib.mkIf cfg.enable
  { services.pipewire = 
    { enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    security.rtkit.enable = true;
  };

}
