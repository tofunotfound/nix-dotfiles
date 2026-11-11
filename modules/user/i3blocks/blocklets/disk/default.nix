{ ... }:

{

  xdg.configFile."i3blocks/blocklets/disk" = 
  { executable = true;
    
    text = 
    ''#!/usr/bin/env bash

      df -h / | awk 'NR==2 {print $4}' | tr -d 'G' | awk '{ free=$1 } END { if (free <= 5) c="color=\047#FF0000\047"; else if (free <= 15) c="color=\047#FFFF00\047"; else c=""; printf "<span %s> %s GB</span>\n", c, free }'
    '';
  };

}
