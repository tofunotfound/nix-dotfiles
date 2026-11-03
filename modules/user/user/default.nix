{ config, pkgs, inputs, ... }:

{

  users.users.tofu = 
  { isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager.users.tofu = { config, pkgs, ... }:
  { home.username = tofu;
    home.homeDirectory = "/home/tofu";
    home.stateVersion = "26.05";

    imports = 
    [ ../alacritty
      ../xresources
      ../fastfetch
      ../fish
      ../gsimplecal
      ../gtk
      ../i3
      ../i3blocks
      ../syncthing
      ../unclutter
      ../rofi
      ../sxhkd
      ../nvim
      ../nixpkgs
      ../dunst
    ];

   home.packages = with pkgs;
   [ yazi
     maim
     playerctl
     mpv
     btop
     firefox
     opencode
     warpd
     inputs.tele-client.packages.${pkgs.system}.default
   ];
  };

}
