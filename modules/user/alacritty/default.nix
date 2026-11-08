{ config, lib, ... }:

let
  cfg = config.myHomeModules.alacritty;
in

{
  
  options.myHomeModules.alacritty.enable = lib.mkEnableOption "add alacritty";

  config = lib.mkIf cfg.enable {
    programs.alacritty = 
    { enable = true;
  
      settings = 
      { font = 
        { size = 10.0;
          
  	normal = 
  	{ family = "JetBrainsMono Nerd Font";
  	  style = "Regular"; 
  	};
  	bold = 
  	{ family = "JetBrainsMono Nerd Font"; 
  	  style = "Bold"; 
  	};
  	italic = 
  	{ family = "JetBrainsMono Nerd Font";
  	  style = "Italic";
  	};
  	bold_italic = 
  	{ family = "JetBrainsMono Nerd Font";
  	  style = "Bold Italic";
  	};
        };
      };
    };
  };
}
