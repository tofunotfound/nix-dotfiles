{ config, pkgs, inputs, ... }:

let
  username = "tofu";
  dotfilesDir = "/home/${username}/.dotfiles";

  userLib = config.home-manager.users.${username};
  symlink = userLib.lib.file.mkOutOfStoreSymlink;

  unstable = import inputs.nixpkgs-unstable 
  { system = pkgs.system;
    config.allowUnfree = true;
  };
in

{

  users.users."${username}" = 
  { isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
  };

  home-manager.users."${username}" = { config, pkg, ... }:
  { home.username = "${username}";
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "26.05";

    imports = 
    [ ../packages/home/default.nix
    ];

   home.packages = with pkgs;
   [ kitty
     fastfetch
     gsimplecal
     i3blocks
     rofi
     sxhkd
     yazi
     maim
     playerctl
     mpv
     btop
     
     unstable.neovim
     unstable.firefox
     unstable.spotatui
   ];


    home.file = 
    { ".Xresources".source = symlink "${dotfilesDir}/.Xresources";
      ".gitconfig".source = symlink "${dotfilesDir}/.gitconfig";
    };

    xdg.configFile =
    { "fastfetch".source = symlink "${dotfilesDir}/.config/fastfetch";
      "fish".source = symlink "${dotfilesDir}/.config/fish";
      "gsimplecal".source = symlink "${dotfilesDir}/.config/gsimplecal";
      "gtk-3.0".source = symlink "${dotfilesDir}/.config/gtk-3.0";
      "i3".source = symlink "${dotfilesDir}/.config/i3";
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
