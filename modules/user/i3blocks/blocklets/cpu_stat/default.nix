{ ... }:

{

  xdg.configFile."i3blocks/blocklets/cpu_stat" = 
  { executable = true;

    text = 
    ''#!/usr/bin/env bash

      cpu=$(top -bn2 -d 0.3 | awk '/%Cpu\(s\):/ {usage=100-$8} END {print int(usage)}')

      temp=$(cat /sys/class/thermal/thermal_zone*/temp | sort -nr | head -n1 | awk '{print int($1/1000)}')

      awk -v c="$cpu" -v t="$temp" 'BEGIN {
        if (c >= 85)      cc="color=\047#FF0000\047";
        else if (c >= 60) cc="color=\047#FFFF00\047";
        else              cc="";

        if (t >= 80)      tc="color=\047#FF0000\047";
        else if (t >= 65) tc="color=\047#FFFF00\047";
        else              tc="";

        printf " <span %s>%s%%</span> (<span %s>%s°C</span>)\n", cc, c, tc, t
      }'
     '';
   };
}
