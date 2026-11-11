{ config, pkgs, inputs, ... }:

{

  wsl.enable = true;
  wsl.defaultUser = "tofu";
  networking.wireless.enable = false;

  networking.hostName = "wsl";

  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "ru_RU.UTF-8";


  programs = 
  { fish.enable = true;  
    tmux.enable = true;
  }; 

  myModules = 
  { default.enable = true;

    boot.systemd.enable = false;

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
