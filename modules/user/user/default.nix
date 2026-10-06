{ config, pkgs, inputs, ... }:

let
  username = "tofu";
  dotfilesDir = "/home/${username}/.dotfiles";

  userLib = config.home-manager.users.${username};
  symlink = userLib.lib.file.mkOutOfStoreSymlink;
in

{

  users.users."${username}" = 
  { isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager.users."${username}" = { config, pkgs, ... }:
  { home.username = "${username}";
    home.homeDirectory = "/home/${username}";
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
    ];

   home.packages = with pkgs;
   [ sxhkd
     yazi
     maim
     playerctl
     mpv
     btop
     firefox
   ];

    xdg.configFile =
    { "mozilla".source = symlink "${dotfilesDir}/.config/mozilla";
      "sxhkd".source = symlink "${dotfilesDir}/.config/sxhkd";
    };
  };

}
