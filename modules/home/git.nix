{ config, lib, pkgs, ... }:

let
  # This script basically lets me choose from among my 1password SSH keys interactively when committin
  # so I don't need to change configs for every project I'm working on
  gitSigningKeyCommand = pkgs.writeShellScript "git-signing-key" ''
    set -euo pipefail

    keys="$(${lib.getExe' pkgs.openssh "ssh-add"} -L)"

    if [ -z "$keys" ]; then
      echo "No SSH keys available from 1Password agent" >&2
      exit 1
    fi

    key="$(printf '%s\n' "$keys" | ${lib.getExe pkgs.fzf})"

    if [ -z "$key" ]; then
      echo "No SSH signing key selected" >&2
      exit 1
    fi

    printf 'key::%s\n' "$key"
  '';
in
{
  home.sessionVariables.SSH_AUTH_SOCK = "${config.home.homeDirectory}/.1password/agent.sock";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings."*" = {
      IdentityAgent = "~/.1password/agent.sock";
    };
  };

  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "catgirlaria";
        email = "catgirlaria@pm.me";
      };

      init.defaultBranch = "main";

      gpg.ssh.defaultKeyCommand = "${gitSigningKeyCommand}";
    };

    signing = {
      format = "ssh";
      signByDefault = true;
    };
  };
}
