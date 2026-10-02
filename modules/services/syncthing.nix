{ config, lib, pkgs, ... }:

{

  options.myFeatures.syncthing = lib.mkEnableOption "syncthing";

  config.services.syncthing = lib.mkIf config.myFeatures.syncthing
  { enable = true;
    user = "tofu";
    dataDir = "/home/tofu";
  };

}

