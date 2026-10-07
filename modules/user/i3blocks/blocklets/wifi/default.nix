{ ... }:

{

  xdg.configFile."i3blocks/blocklets/wifi" = 
  { executable = true;

    text = ''
       #!/usr/bin/env bash

       STATE_FILE="/tmp/i3blocks_wifi_show_ssid"

       if [ "$BLOCK_BUTTON" -eq 1 ]; then
         if [ -f "$STATE_FILE" ]; then
           rm "$STATE_FILE"
         else
           touch "$STATE_FILE"
         fi
       fi

       iface=$(ls /sys/class/net | grep -E '^w(lan|lp)' | head -n1)

       if [ -n "$iface" ] && [ "$(cat /sys/class/net/$iface/operstate 2>/dev/null)" = "up" ]; then
     
         quality=$(awk -v ifc="$iface:" '$1 == ifc {print int($3 * 100 / 70)}' /proc/net/wireless)
         [ -z "$quality" ] && quality=0
     
         if [ "$quality" -ge 60 ]; then
           color="#00FF00"
         elif [ "$quality" -ge 30 ]; then
           color="#FFFF00"
         else
           color="#FF0000"
         fi
     
         if [ -f "$STATE_FILE" ]; then
           ssid=$(nmcli -t -f GENERAL.CONNECTION device show "$iface" 2>/dev/null | cut -d: -f2)
           [ -z "$ssid" ] && ssid="Connected"
         
           echo "<span color=\"$color\">$ssid (''${quality}%)</span>"
         else
           echo "<span color=\"$color\">''${quality}%</span>"
         fi
       else
         echo "<span color=\"#FF0000\">down</span>"
       fi
    '';
  };

}
