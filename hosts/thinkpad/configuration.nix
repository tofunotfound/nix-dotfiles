{ config, pkgs, inputs, ... }:

{

  networking.hostName = "laptop";

  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "ru_RU.UTF-8";

  nixpkgs.config.allowUnfree = true;  

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  programs = 
  { fish.enable = true;  
    tmux.enable = true;

    steam.enable = true;
  }; 

  myModules =
  { boot.systemd.enable = true;

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
      xclip.enable = true;
      font.enable = true;
    };
  };


  system.stateVersion = "26.05";

}
