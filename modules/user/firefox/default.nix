  { config, lib, pkgs, ... }:
 
  let
    cfg = config.myHomeModules.packages;
  in
 
  {
 
    options.myHomeModules.packages.firefox.enable = lib.mkEnableOption "add firefox";
 
    config = lib.mkIf cfg.firefox.enable
    { programs.firefox = 
      { enable = true;
        profiles.default =
        { isDefault = true;
 
  	extensions = 
  	{ force = true;
  	};
 
          settings = 
     	  { "browser.toolbars.bookmarks.visibility" = "always";
            "browser.tabs.firefox-view" = false;
            "browser.tabs.closeWindowWithLastTab" = true;
            "browser.profiles.enabled" = true;
            "browser.toolbars.bookmarks.showOtherBookmarks" = true;
            "browser.engagement.home-button.has-used" = false; 
            "browser.engagement.library-button.has-used" = false;
            "browser.download.everywhere.enabled" = false;
            "browser.menu.showReportSiteIssue" = false;
            "pageActions.urlbarActions.share" = false;
            "browser.messaging-system.whatsNewPanel.enabled" = false;
            "browser.aboutConfig.showWarning" = false;
            "browser.uiCustomization.state" = ''{"placements":{"widget-overflow-fixed-list":[],"unified-extensions-area":["sponsorblocker_ajay_app-browser-action","_ddc62400-f22d-4dd3-8b4a-05837de53c2e_-browser-action","ublock0_raymondhill_net-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","_732216ec-0dab-43bb-ac85-4b5e1977599d_-browser-action"],"nav-bar":["back-button","forward-button","vertical-spacer","stop-reload-button","urlbar-container","unified-extensions-button"],"toolbar-menubar":["menubar-items"],"TabsToolbar":[],"vertical-tabs":["tabbrowser-tabs"],"PersonalToolbar":["personal-bookmarks"]},"seen":["reset-pbm-toolbar-button","ublock0_raymondhill_net-browser-action","_762f9885-5a13-4abd-9c77-433dcd38b8fd_-browser-action","_ddc62400-f22d-4dd3-8b4a-05837de53c2e_-browser-action","sponsorblocker_ajay_app-browser-action","_732216ec-0dab-43bb-ac85-4b5e1977599d_-browser-action","smartwindow-group-tabs-button","ai-window-toggle","developer-button","screenshot-button"],"dirtyAreaCache":["nav-bar","unified-extensions-area","TabsToolbar","vertical-tabs"],"currentVersion":28,"newElementCount":0}'';
    
             "toolkit.cosmeticAnimations.enabled" = false;
    	     "browser.bookmarks.addedImportButton" = false;
    	     "browser.aboutwelcome.enabled" = false;
    	     "browser.startup.homepage_override.mstone" = "ignore";
    	     "datareporting.policy.dataSubmissionPolicyBypassNotification" = true;
    
            "sidebar.verticalTabs" = true; 
            "sidebar.position_start" = true;
  	     "sidebar.newTool.migration.passwords" = ''{"visibilityPref":"browser.contextual-password-manager.enabled","alreadyShown":true}'';
            "sidebar.main.tools" = "syncedtabs";
    
            "extensions.pocket.enabled" = false;
            "browser.urlbar.pocket.feature.enabled" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
            "browser.newtabpage.activity-stream.feeds.discoverystreamfeed" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.vpn_promo.enabled" = false;
            "browser.promo.relay.enabled" = false;
    
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "browser.ping-centre.telemetry" = false;
    
            "breakpad.reportURL" = "";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
    
            "experiments.supported" = false;
            "experiments.enabled" = false;
            "experiments.manifest.uri" = "";
    
            "browser.privacytrackingprotection.enabled" = true;
            "browser.privacytrackingprotection.pbmode.enabled" = true;
            "privacy.trackingprotection.cryptomining.enabled" = true;
            "privacy.trackingprotection.fingerprinting.enabled" = true;
            "network.http.speculative-parallel-limit" = 0;
    
            "reader.parse-on-load.enabled" = true;
            "extensions.screenshots.disabled" = true;
            "identity.fxaccounts.enabled" = true;
            "devtools.chrome.enabled" = true;
           };
         };
       };
     };

 }
