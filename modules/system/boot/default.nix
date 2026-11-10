{ config, lib, pkgs, ... }:

let
  cfg = config.myModules.boot
in

{

  options.myModules.boot.systemd.enable = lib.EnableOption "boot - systemd"

  config = 
  { boot =
    { loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      kernelPacksges = pkgs.linuxPackages_latest;
      kernelParams = [ "mem_sleep_defaul=deep" ];
    };
  };

}
