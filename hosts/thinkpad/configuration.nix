{ config, pkgs, inputs, ... }:

{

  networking.hostName = "laptop";

  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "ru_RU.UTF-8";


  programs = 
  { fish.enable = true;  
    tmux.enable = true;

    steam.enable = false;
  }; 

  myModules =
  { default.enable = true;

    boot.systemd.enable = true;

    bluetooth.enable = true;
    git.enable = true;
    xserveri3.enable = true;
    pipewire.enable = true;
    networkmanager.enable = true;
    fstrim.enable = true;
    zram.enable = true;
    openssh.enable = true;
    
    packages = 
    { default.enable = true;
      brightnessctl.enable = true;
      font.enable = true;
    };
  };


  system.stateVersion = "26.05";

}
