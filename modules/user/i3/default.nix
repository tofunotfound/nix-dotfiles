{ pkgs, ... }:

{

  xsession =
  { windowManager.i3 = 
    { enable = true;
    
      config = 
    
      let
        mod = "Mod4";
      in
    
      { modifier = mod;

        fonts = { names = [ "JetBrainsMono Nerd Font" ]; size = 7.0; };

	window.titlebar = false;

	keybindings = {};
	modes = {};

	bars = 
	[{ fonts = { names = [ "JetBrainsMono Nerd Font" ]; size = 7.0; };
	   statusCommand = "${pkgs.i3blocks}/bin/i3blocks -c ~/.config/i3blocks/config"; 
	   extraConfig = "bindsym button1 exec --no-startup-id gsimplecal";
	}];

	startup =
	[ { command = "dex --autostart --environment i3"; notification = false; }
	  { command = "setxkbmap -layout 'us,ru' -option 'grp:win_space_toggle'"; always = true; notification = false; }
	  { command = "-merge ~/.Xresources"; notification = false; }
	  { command = "sxhkd"; always = true; notification = false; }
	];
      };
    };
  };

}
