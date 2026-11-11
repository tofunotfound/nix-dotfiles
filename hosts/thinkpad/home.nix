{ ... }:

{
  
  myHomeModules = 
  { alacritty.enable = true;
    dunst.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    gsimplecal.enable = true;
    gtk-3.enable = true;
    i3.enable = true;
    i3blocks.enable = true;
    nvim.enable = true;
    rofi.enable = true;
    sxhkd.enable = true;
    syncthing.enable = true;
    unclutter.enable = true;
    xresources.enable = true;

    packages = 
    { default.enable = true;
      playerctl.enable = true;
      mpv.enable = true;
      maim.enable = true;
      warpd.enable = true;
      firefox.enable = true;
      opencode.enable = false;
      tele.enable = true;
    };
  };

}
