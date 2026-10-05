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
        { markup = "pango";
          label = "CPU";
          command = "~/.dotfiles/.config/i3blocks/blocklets/cpu_stat";
	  interval = 1;
        };
        memory = after [ "cpu_stat" ]
	{ label = "RAM";
          command = "~/.dotfiles/.config/i3blocks/blocklets/memory";
          interval = 1;
	};
        disk = after [ "memory" ]
	{ markup = "pango";
          label = "/:";
          command = "~/.dotfiles/.config/i3blocks/blocklets/disk";
          interval = 1;
	};
        wifi = after [ "disk" ]
	{ markup = "pango";
          command = "~/.dotfiles/.config/i3blocks/blocklets/wifi";
          interval = 1;
          signal = 1;
	};
        battery = after [ "wifi" ]
	{ markup = "pango";
          label = "BAT";
          command = "~/.dotfiles/.config/i3blocks/blocklets/battery";
          interval = 1;
	};
        volume = after [ "battery" ]
	{ markup = "pango";
          command = "~/.dotfiles/.config/i3blocks/blocklets/volume";
          interval = "once";
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
