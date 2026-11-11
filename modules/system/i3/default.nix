{ config, lib, ... }:

let
  cfg = config.myModules.xserveri3;
in

{ 
  
  options.myModules.xserveri3.enable = lib.mkEnableOption "add i3";

  config = lib.mkIf cfg.enable {
    services =
    { displayManager.ly.enable = true;
      displayManager.defaultSession = "none+i3";
  
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
  };

}
