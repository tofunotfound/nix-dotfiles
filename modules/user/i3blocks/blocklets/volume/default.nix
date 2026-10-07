{ ... }:

{

  xdg.configFile."i3blocks/blocklets/volume" = 
  { executable = true;

    text = ''
       #!/usr/bin/env bash

       wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{vol=int($2*100)"%"} /MUTED/ {print "<span color=\"#FFFF00\">muted ("vol")</span>"; exit} {print vol}'
    '';
  };

}
