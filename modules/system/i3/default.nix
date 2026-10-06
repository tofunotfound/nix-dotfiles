{ ... }:

{ 

  services =
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
