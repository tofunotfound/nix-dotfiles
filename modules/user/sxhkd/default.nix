{ pkgs, ... }:

{

  services.sxhkd = 
  { enable = true;
    
    keybindings = 
    { "XF86Audio{Raise,Lower}Volume" = "wpctl set-volume @DEFAULT_SINK@ {5%+,5%-} && pkill -RTMIN+10 i3blocks";
      "XF86AudioMute" = "wpctl set-mute @DEFAULT_SINK@ toggle && pkill -RTMIN+10 i3blocks";
      "XF86AudioMicMute" = "wpctl set-mute @DEFAULT_SOURCE@ toggle";
      "XF86Audio{Next,Prev,Play}" = "playerctl {next,previous,play-pause}";
      "XF86Tools" = "bluetoothctl power on && bluetoothctl connect AC:80:0A:E6:10:3C";

      "super + {_,shift +}{h,j,k,l}" = "i3-msg {focus,move}{left,down,up,right}";
      "super + {_,shift + } + {1-9,0}" = "i3-msg {workspace number,move container to workspace number}{1-9,10}";
      "super + {m,n,f,s,w,e,q}" = "i3-msg {split h,split v,fullscreen toggle,layout stacking,layout tabbed,layout toggle split,kill}";
      "super + shift + space" = "i3-msg floating toggle";
      "super + a ; {j,k}" = "i3-msg focus {parent,child}";
      "super + shift {c,r,e}" = "{i3-msg reload, pkill sxhkd && i3-msg restart, i3-nagbar -t \"Warning\" -m \"Выход??\" -B \"ДА\" \"i3-msg exit\"}";
      "super + ctrl {h,k,j,l} " = "i3-msg {resize shrink width 10 px or 10 ppt, resize grow height 10 px or 10 ppt, resize shrink height 10 px or 10 ppt, resize grow width 10 px or 10 ppt}";
      
      "ctrl + space" = "rofi -show drun -show-icons";
      
      "Print" = "bash -c 'maim -s | tee -p \"$HOME/M/Скрины/\$(date +'%Y-%m-%d_%H-%M-%S').png\" | xclip -selection clipboard -t image/png'";
      "super + Return" = "${pkgs.alacritty}/bin/alacritty";

      "XF86MonBrightness{Up,Down}" = "brightnessctl set {+5%,5%-}";
      "XF86Display" = "[ \"\$(brightnessctl get)\" -gt 0 ] && brightnessctl get > /tmp/brightness_back && brightnessctl set 0 || brightnessctl set \$(cat /tmp/brightness_back)";
    };
  };

}
