{ config, pkgs, inputs, ... }:

{

  boot = 
  { loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [ "mem_sleep_default=deep" ];
  };

  networking.hostName = "laptop";

  time.timeZone = "Europe/Minsk";
  i18n.defaultLocale = "ru_RU.UTF-8";

  nixpkgs.config.allowUnfree = true;  

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  zramSwap.enable = true;

  system.stateVersion = "26.05";

}
