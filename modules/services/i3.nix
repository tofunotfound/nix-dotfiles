{ config, lib, pkgs, ... }:

{
  
  options.myFeatures.xserverI3 = lib.mkEnableOption "xserver + i3";  

  config.services = lib.mkIf config.myFeatures.xserverI3
  { displayManager.ly.enable = true;

    xserver = 
    { enable = true;

      xkb = 
      { layout = "ru";
        variant = "";
      };

      windowManager.i3 = 
      { enable = true;
        extraPackages = [];
      };

      desktopManager = 
      { xterm.enable = false;
      };
    };
  };

}
