{ pkgs, glob, ... }:

{
  home.packages = with pkgs; [
    brave
    tela-icon-theme
    #nix
    nix-output-monitor
    nixfmt-tree
    nixfmt
    nil
    nixd
    devenv
    nix-init

    # cli
    fastfetch
    bat
    zoxide
    eza
  ];

  programs.kitty = {
    enable = true;
    font = {
      name = "FiraCode Nerd Font";
      size = 13;
      package = pkgs.nerd-fonts.fira-code;
    };

    settings = {
      disable_ligatures = "never";
    };
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.fish = {
    interactiveShellInit = ''
      if status is-interactive
        fastfetch
        echo
      end
    '';
    functions = {
      fish_greeting = "";
    };
    plugins = [
      { name = "autopair"; src = pkgs.fishPlugins.autopair.src; }
      { name = "tide"; src = pkgs.fishPlugins.tide.src; }
    ];
    shellAliases = {
      ls = "eza --icons=always --group-directories-first";
      nhs = "nh os switch";
      nhb = "nh os boot";
      clean = "nh clean all";
      addsw = "git add ~/nixos/. && nh os switch";
      cat = "bat";
      cd = "z";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph --decorate";
    };
  };
}
