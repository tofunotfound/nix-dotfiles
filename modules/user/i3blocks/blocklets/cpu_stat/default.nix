{ ... }:

{

  xdg.configFile."i3blocks/blocklets/cpu_stat" = 
  { executable = true;

    text = ''
       #!/usr/bin/env bash

       cpu=$(top -bn2 -d 0.3 | awk '/%Cpu\(s\):/ {usage=100-$8} END {print int(usage)}')

       temp=$(cat /sys/class/thermal/thermal_zone*/temp | sort -nr | head -n1 | awk '{print int($1/1000)}')

       awk -v c="$cpu" -v t="$temp" 'BEGIN {
         if (c >= 85)       cc="#FF0000";
         else if (c >= 60)  cc="#FFFF00";
         else               cc="#FFFFFF";

         if (t >= 80)       tc="#FF0000";
	 else if (t >= 65)  tc="#FFFF00";
         else               tc="#FFFFFF";

         printf " <span color=\"%s\">%s%%</span> (<span color=\"%s\">%s°C</span>)\n", cc, c, tc, t
       }'
     '';
   };
}
