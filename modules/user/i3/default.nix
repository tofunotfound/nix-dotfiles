{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.i3;
in

{

  options.myHomeModules.i3.enable = lib.mkEnableOption "i3 settings";

  config = lib.mkIf cfg.enable 
  { xsession =
    { windowManager.i3 = 
      { enable = true;
      
        config = 
      
        let
          mod = "Mod4";
          mauve = "#cba6f7";    
          base = "#1e1e2e";
          text = "#cdd6f4";
          rosewater = "#f5e0dc";
          overlay0 = "#6c7086";
          peach = "#fab387";
          surface0 = "#313244"; 
          subtext0 = "#a6adc8"; 
        in
      
        { modifier = mod;
          
	  colors = {
                background = base;
          
                focused = {
                  border = mauve;
                  background = base;
                  text = text;
                  indicator = rosewater;
                  childBorder = mauve;
                };
          
                focusedInactive = {
                  border = overlay0;
                  background = base;
                  text = text;
                  indicator = rosewater;
                  childBorder = overlay0;
                };
          
                unfocused = {
                  border = overlay0;
                  background = base;
                  text = text;
                  indicator = rosewater;
                  childBorder = overlay0;
                };
          
                urgent = {
                  border = peach;
                  background = base;
                  text = peach;
                  indicator = overlay0;
                  childBorder = peach;
                };
          
                placeholder = {
                  border = overlay0;
                  background = base;
                  text = text;
                  indicator = overlay0;
                  childBorder = overlay0;
                };
              };
         
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
  };

}
