{ config, lib, ... }:

let
  cfg = config.myModules.openssh;
in

{

  options.myModules.openssh.enable = lib.mkEnableOption "enable openssh";

  config = lib.mkIf cfg.enable
  { services.openssh.enable = true;
  };

}
