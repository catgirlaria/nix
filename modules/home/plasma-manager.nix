{ pkgs, ... }:

{
  home.packages = with pkgs; [
    darkly
  ];

  programs.plasma = {
    enable = true;
    workspace.lookAndFeel = "org.kde.breezedark.desktop";
    workspace.widgetStyle = "darkly";
    powerdevil.AC.autoSuspend.action = "nothing";
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    spectacle.shortcuts.launch = "Pause";
  };

  programs.kate = {
    enable = true;
    editor.indent.width = 2;
    editor.tabWidth = 2;
  };
}
