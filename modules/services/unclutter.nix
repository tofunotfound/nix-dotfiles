{ config, lib, pkgs, ... }:

{
  
  options.myFeatures.unclutter = lib.mkEnableOption "unclutter";

  config.services.unclutter = lib.mkIf config.myFeatures.unclutter 
  { enable = true;
    package = pkgs.unclutter-xfixes;
    timeout = 1;
    extraOptions = [ "root" ];
  };

}
