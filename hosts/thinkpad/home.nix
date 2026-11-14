{ ... }:

{
 
  myHomeModules =
  { alacritty.enable = true;
    dunst.enable = true;
    fastfetch.enable = true;
    fish.enable = true;
    gtk.enable = true;
    i3.enable = true;
    i3blocks.enable = true;
    nvim.enable = true;
    rofi.enable = true;
    rofi.dpi = 200;

    sxhkd.enable = true;
    syncthing.enable = true;
    unclutter.enable = true;
    xresources.enable = true;
    xresources.dpi = 140;

    packages =
    { default.enable = true;
      playerctl.enable = true;
      mpv.enable = false;
      maim.enable = true;
      warpd.enable = true;
      firefox.enable = true;
      opencode.enable = true;
      tele.enable = true;
    };

    theme =
    { catppuccin.enable = true;
    };
  };

}
