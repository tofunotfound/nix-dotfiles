{ config, lib, ... }:

let
  cfg = config.myHomeModules.dunst;
in

{

  options.myHomeModules.dunst.enable = lib.mkEnableOption "add dunst";

  config = lib.mkIf cfg.enable {
    services.dunst = 
    { enable = true;
      
      settings = 
      { global = 
        { origin = "bottom-right";
          offset = "10x30";
  	width = 300;
  	height = 100;
  	frame_width = 1;
  	padding = 10;
  	horizontal_padding = 10;
  
  	font = "JetBrains Mono 11";
        };
  
     };
    };
  };

}
