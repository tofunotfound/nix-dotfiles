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

    nixpkgs.config.allowUnfree = true;

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
    ];

   home.packages = with pkgs;
   [ yazi
     maim
     playerctl
     mpv
     btop
     firefox
   ];

    xdg.configFile =
    { "mozilla".source = symlink "${dotfilesDir}/.config/mozilla";
    };
  };

}
