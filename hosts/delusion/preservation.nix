{
  preservation = {
    enable = true;
    preserveAt."/persist" = {
      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
        {
          file = "/etc/ssh/ssh_host_rsa_key";
        }
        {
          file = "/etc/ssh/ssh_host_ed25519_key";
        }
        {
          file = "/var/lib/systemd/random-seed";
          inInitrd = true;
        }
      ];
      directories = [
        "/etc/secureboot"
        "/var/lib"
        "/var/log"
        "/etc/nixos"
        "/var/lib/flatpak"
        "/var/db/sudo/lectured"
        "/etc/NetworkManager/system-connections"
      ];
    };
  };

  # needed for the stupid `machine-id`
  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  # let the service commit the transient ID to the persistent volume (idk what this does)
  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };
}
