{ config, pkgs, ... }:

{

  networking.hostName = "wsl";

  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "ru_RU.UTF-8";


  programs = 
  { fish.enable = true;  
    tmux.enable = true;
  }; 

  myModules = 
  { boot = "wsl";

    default.enable = true;

    bluetooth.enable = false;
    git.enable = true;
    xserveri3.enable = false;
    pipewire.enable = false;
    networkmanager.enable = false;
    fstrim.enable = false;
    zram.enable = false;
    openssh.enable = true;

    packages = 
    { default.enable = true;
      brightnessctl.enable = false;
      font.enable = false;
    };
  };


  system.stateVersion = "26.05";

}
