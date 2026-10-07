{ ... }:

{

  xdg.configFile."i3blocks/blocklets/disk" = 
  { executable = true;
    
    text = ''
       #!/usr/bin/env bash

       df -h / | awk 'NR==2 {print $4}' | tr -d 'G' | awk '{ free=$1 } END { if (free <= 5) color="#FF0000"; else if (free <= 15) color="#FFFF00"; else color="#FFFFFF"; printf "<span color=\"%s\"> %s GB</span>\n", color, free }'
    '';
  };

}
