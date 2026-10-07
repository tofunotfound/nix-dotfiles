{ lib, ... }:

let
  after = lib.hm.dag.entryAfter;
in

{
  imports = 
  [ ./blocklets/battery
    ./blocklets/cpu_stat
    ./blocklets/disk
    ./blocklets/memory
    ./blocklets/time
    ./blocklets/volume
    ./blocklets/wifi    
  ];

  programs.i3blocks = 
  { enable = true;

    bars = 
    { config = 
      { cpu_stat = 
        { command = "~/.config/i3blocks/blocklets/cpu_stat";
	  interval = 1;
          label = "CPU";
          markup = "pango";
        };
        memory = after [ "cpu_stat" ]
        { command = "~/.config/i3blocks/blocklets/memory";
          interval = 1;
	  label = "RAM";
	};
        disk = after [ "memory" ]
        { command = "~/.config/i3blocks/blocklets/disk";
          interval = 1;
          label = "/:";
	  markup = "pango";
	};
        wifi = after [ "disk" ]
        { command = "~/.config/i3blocks/blocklets/wifi";
          interval = 1;
	  markup = "pango";
          signal = 1;
	};
        battery = after [ "wifi" ]
        { command = "~/.config/i3blocks/blocklets/battery";
          interval = 1;
          label = "BAT";
	  markup = "pango";
	};
        volume = after [ "battery" ]
        { command = "~/.config/i3blocks/blocklets/volume";
          interval = "once";
	  markup = "pango";
          signal = 10;
	};
        time = after [ "volume" ]
	{ command = "~/.config/i3blocks/blocklets/time";
          interval = 1;
	};
      };
    };
  };

}
