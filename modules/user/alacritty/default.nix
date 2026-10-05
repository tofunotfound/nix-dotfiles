{ config, lib, pkgs, ... }:

{

  programs.alacritty = 
  { enable = true;
    package = pkgs.alacritty;

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

}
