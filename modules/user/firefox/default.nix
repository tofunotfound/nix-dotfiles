{ config, lib, pkgs, ... }:

let
  cfg = config.myHomeModules.packages;
in

{

  options.myHomeModules.packages.firefox.enable = lib.mkEnableOption "add firefox";

  config = lib.mkIf cfg.firefox.eanble
  { programs.firefox = 
    { enable = true;
      profiles.default =
      { isDefault = true;
  
        extensions = with pkgs.nur.repos.rycee.firefox-addons;
	[ ublock-origin
          catppuccin-mocha-mauve
        ];
  
        settings = 
	{ "browser.toolbars.bookmarks.visibility" = "always";
          "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["ublock0_raymondhill_net-browser-action","sponsorblocker_ajay_app-browser-action","_ddc62400-f22d-4dd3-8b4a-05837de53c2e_-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","firefoxcolor_mozilla_com-browser-action","_732216ec-0dab-43bb-ac85-4b5e1977599d_-browser-action"],"nav-bar":["sidebar-button","back-button","forward-button","stop-reload-button","customizableui-special-spring1","vertical-spacer","urlbar-container","customizableui-special-spring2","downloads-button","fxa-toolbar-menu-button","reset-pbm-toolbar-button","unified-extensions-button","alltabs-button","smartwindow-group-tabs-button","ai-window-toggle"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["personal-bookmarks"]},"seen":["reset-pbm-toolbar-button","smartwindow-group-tabs-button","ai-window-toggle","developer-button","screenshot-button","_ddc62400-f22d-4dd3-8b4a-05837de53c2e_-browser-action","sponsorblocker_ajay_app-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","firefoxcolor_mozilla_com-browser-action","ublock0_raymondhill_net-browser-action","_732216ec-0dab-43bb-ac85-4b5e1977599d_-browser-action"],"dirtyAreaCache":["nav-bar","TabsToolbar","vertical-tabs","PersonalToolbar","unified-extensions-area","toolbar-menubar"],"currentVersion":28,"newElementCount":3}'';
          "toolkit.telemetry.unified" = false;
          "toolkit.telemetry.enabled" = false;
          "toolkit.telemetry.server" = "data:,";
          "toolkit.telemetry.archive.enabled" = false;
          "toolkit.telemetry.newProfilePing.enabled" = false;
          "toolkit.telemetry.shutdownPingSender.enabled" = false;
          "toolkit.telemetry.updatePing.enabled" = false;
          "toolkit.telemetry.bhrPing.enabled" = false;
          "toolkit.telemetry.firstShutdownPing.enabled" = false;
  
          "breakpad.reportURL" = "";
          "browser.tabs.crashReporting.sendReport" = false;
          "browser.crashReports.unsubmittedCheck.enabled" = false;
          "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
  
          "experiments.supported" = false;
          "experiments.enabled" = false;
          "experiments.manifest.uri" = "";
          "browser.ping-centre.telemetry" = false;
  
          "browser.newtabpage.activity-stream.showSponsored" = false;
          "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
          "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
  
          "extensions.pocket.enabled" = false;
          "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
  
          "browser.privacytrackingprotection.enabled" = true;
          "browser.privacytrackingprotection.pbmode.enabled" = true;
          "privacy.trackingprotection.cryptomining.enabled" = true;
          "privacy.trackingprotection.fingerprinting.enabled" = true;
  
          "network.http.speculative-parallel-limit" = 0;
          "browser.aboutConfig.showWarning" = false;
        };
      };
    };
  };

}
