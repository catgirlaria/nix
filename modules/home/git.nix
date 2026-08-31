{ config, lib, pkgs, ... }:

let
  gitSigningKeyCommand = pkgs.writeShellScript "git-signing-key" ''
    key="$(${lib.getExe' pkgs.openssh "ssh-add"} -L | ${lib.getExe' pkgs.coreutils "head"} -n 1)"

    if [ -z "$key" ]; then
      echo "No SSH key available from agent" >&2
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
