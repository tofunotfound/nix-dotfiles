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
        
          "sidebar.verticalTabs" = true; 
          "sidebar.position_start" = true;
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
