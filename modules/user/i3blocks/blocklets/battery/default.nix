{ ... }:

{

  xdg.configFile."i3blocks/blocklets/battery" = 
  { executable = true; 
      
    text = ''
       #!/usr/bin/env bash

       now=0
       full=0
       power=0
       status="Discharging"
       time_str=""
       status_text=""

       for b in /sys/class/power_supply/BAT*; do
         [ -d "$b" ] || continue
      
         n=$(cat "$b/energy_now" "$b/charge_now" 2>/dev/null | head -n1)
         f=$(cat "$b/energy_full" "$b/charge_full" 2>/dev/null | head -n1)
         p=$(cat "$b/power_now" "$b/current_now" 2>/dev/null | head -n1)
         s=$(cat "$b/status" 2>/dev/null)
      
         now=$((now + ''${n:-0}))
         full=$((full + ''${f:-0}))
         power=$((power + ''${p:-0}))
      
         [ "$s" = "Charging" ] && status="Charging"
       done

       if [ "$full" -gt 0 ]; then
         pct=$(( (now * 100) / full ))
      
         if [ "$power" -gt 0 ] && [ "$pct" -ne 100 ]; then
           if [ "$status" = "Discharging" ]; then
             rem_min=$(( (now * 60) / power ))
           else
             rem_min=$(( ((full - now) * 60) / power ))
           fi
          
           h=$((rem_min / 60))
           m=$((rem_min % 60))
           time_str=$(printf " (%02d:%02d)" $h $m)
         fi
      
         if [ "$status" = "Charging" ]; then
           color="#00FF00"
         else
           if [ "$pct" -le 15 ]; then
             color="#FF0000"
           elif [ "$pct" -le 35 ]; then
              color="#FFFF00"
           else
              color="#FFFFFF"
           fi
         fi
      
       echo "<span color=\"$color\"> ''${pct}%''${time_str}''${status_text}</span>"

       else
         echo "No BAT"
       fi
    '';
  };

}
