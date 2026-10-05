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
      ../git
      ../fastfetch
      ../fish
      ../gsimplecal
      ../gtk
    ];

   home.packages = with pkgs;
   [ i3blocks
     rofi
     sxhkd
     yazi
     maim
     playerctl
     mpv
     btop
     neovim
     firefox
     spotatui
   ];

    xdg.configFile =
    { "i3".source = symlink "${dotfilesDir}/.config/i3";
      "i3blocks".source = symlink "${dotfilesDir}/.config/i3blocks";
      "mozilla".source = symlink "${dotfilesDir}/.config/mozilla";
      "nvim".source = symlink "${dotfilesDir}/.config/nvim";
      "ookla".source = symlink "${dotfilesDir}/.config/ookla";
      "rofi".source = symlink "${dotfilesDir}/.config/rofi";
      "spotatui".source = symlink "${dotfilesDir}/.config/spotatui";
      "sxhkd".source = symlink "${dotfilesDir}/.config/sxhkd";
      "syncthing".source = symlink "${dotfilesDir}/.config/syncthing";
    };
  };

}
