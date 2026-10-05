{ lib, ... }:

let
  after = lib.hm.dag.entryAfter;
in

{

  programs.i3blocks = 
  { enable = true;

    bars = 
    { config = 
      { cpu_stat = 
        { command = "~/.dotfiles/.config/i3blocks/blocklets/cpu_stat";
	  interval = 1;
          label = "CPU";
          markup = "pango";
        };
        memory = after [ "cpu_stat" ]
        { command = "~/.dotfiles/.config/i3blocks/blocklets/memory";
          interval = 1;
	  label = "RAM";
	};
        disk = after [ "memory" ]
        { command = "~/.dotfiles/.config/i3blocks/blocklets/disk";
          interval = 1;
          label = "/:";
	  markup = "pango";
	};
        wifi = after [ "disk" ]
        { command = "~/.dotfiles/.config/i3blocks/blocklets/wifi";
          interval = 1;
	  markup = "pango";
          signal = 1;
	};
        battery = after [ "wifi" ]
        { command = "~/.dotfiles/.config/i3blocks/blocklets/battery";
          interval = 1;
          label = "BAT";
	  markup = "pango";
	};
        volume = after [ "battery" ]
        { command = "~/.dotfiles/.config/i3blocks/blocklets/volume";
          interval = "once";
	  markup = "pango";
          signal = 10;
	};
        time = after [ "volume" ]
	{ command = "~/.dotfiles/.config/i3blocks/blocklets/time";
          interval = 1;
	};
      };
    };
  };

}
