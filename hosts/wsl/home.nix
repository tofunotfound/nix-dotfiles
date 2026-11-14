{ ... }:

{
  
  myHomeModules = 
  { alacritty.enable = false;
    dunst.enable = false;
    fastfetch.enable = true;
    fish.enable = true;
    gtk-3.enable = false;
    i3.enable = false;
    i3blocks.enable = false;
    nvim.enable = true;
    rofi.enable = false;
    sxhkd.enable = false;
    syncthing.enable = false;
    unclutter.enable = false;
    xresources.enable = false;

    packages = 
    { default.enable = true;
      playerctl.enable = false;
      mpv.enable = false;
      maim.enable = false;
      warpd.enable = false;
      firefox.enable = false;
      opencode.enable = false;
      tele.enable = false;
    };

    theme =
    { catppuccin.enable = false;
    };
  };

}
