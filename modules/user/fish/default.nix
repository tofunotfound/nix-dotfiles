{ config, lib, ... }:

let
  cfg = config.myHomeModules.fish;
in

{

  options.myHomeModules.fish.enable = lib.mkEnableOption "add fish";

  config = lib.mkIf cfg.enable {
    programs.fish = 
    { enable = true;
  
      interactiveShellInit = "set fish_greeting";
    };
  };

}
