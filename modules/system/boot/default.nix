{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.myModules.boot;
in

{

  options.myModules.boot = lib.mkOption
  { type = lib.types.enum [ "systemd" "wsl" ];
    default= "systemd";
  };

  config = lib.mkMerge
  [ (lib.mkIf (cfg == "systemd")
    { boot =
      { loader.systemd-boot.enable = true;
        loader.efi.canTouchEfiVariables = true;
        kernelPackages = pkgs.linuxPackages_latest;
        kernelParams = [ "mem_sleep_defaul=deep" ];
      };
    })

    (lib.mkIf (cfg == "wsl")
    { wsl.enable = true;
      wsl.defaultUser = "tofu";
      networking.wireless.enable = false;
    })
  ];

}
