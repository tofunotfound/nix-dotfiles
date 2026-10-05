{ pkgs, ... }:

{

  home.packages = [ pkgs.gsimplecal ];

  xdg.configFile."gsimplecal/config".text = '' 
     [settings]
     show_calendar = 1
     show_timezones = 0
     mark_today = 1
     mainwindow_yoffset = -43
     mainwindow_xoffset = 0
     close_on_unfocus = 1	
  '';

}
