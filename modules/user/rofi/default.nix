{ pkgs, ... }:

{

  programs.rofi = 
  { enable = true;

    theme = "${pkgs.rofi}/share/rofi/themes/Arc-Dark";
    
    extraConfig = 
    { dpi = 200;
    };
  };

}
