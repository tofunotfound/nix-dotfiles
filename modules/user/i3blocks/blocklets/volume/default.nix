{ ... }:

{

  xdg.configFile."i3blocks/blocklets/volume" = 
  { executable = true;

    text = 
    ''#!/usr/bin/env bash

      wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{vol=int($2*100)"%"} /MUTED/ {print "<span color=\"#FFFF00\">muted ("vol")</span>"; exit} {print vol}'

      if wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q "MUTED"; then
        brightnessctl --device="platform::mute" set 1 >/dev/null 2>&1
      else
        brightnessctl --device="platform::mute" set 0 >/dev/null 2>&1
      fi

      if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
        brightnessctl --device="platform::micmute" set 1 >/dev/null 2>&1
      else
        brightnessctl --device="platform::micmute" set 0 >/dev/null 2>&1
      fi
    '';
  };

}
