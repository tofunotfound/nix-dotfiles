{ ... }:

{

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

      urgency_low = 
      { background = "#1e1e2e";
        foreground = "#cdd6f4";
	frame_color = "#89b4fa";
	timeout = 5;
      };

      urgency_normal =
      { background = "#1e1e2e";
        foreground = "#cdd6f4";
	frame_color = "#89b4fa";
	timeout = 8;
      };

      urgency_critical =
      { background = "#1e1e2e";
        foreground = "#cdd6f4";
	frame_color = "#f38ba8";
	timeout = 0;
      };
    };
  };

}
