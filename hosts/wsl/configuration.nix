{ config, pkgs, inputs, ... }:

{

  boot = 
  { loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  networking.hostName = "laptop";

  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "ru_RU.UTF-8";

  nixpkgs.config.allowUnfree = true;  

  nix.settings.experimental-features = [ "nix-command" "flakes" ];


  programs = 
  { fish.enable = true;  
    tmux.enable = true;
  }; 

  myModules = 
  { bluetooth.enable = false;
    git.enable = true;
    xserveri3.enable = false;
    pipewire.enable = false;
    networkmanager.enable = true;
    fstrim.enable = true;
    zram.enable = false;
    openssh.enable = true;
    
    packages = 
    { default.enable = true;
      brightnessctl.enable = false;
      xclip.enable = false;
      font.enable = false;
    };
  };


  system.stateVersion = "26.05";

}
