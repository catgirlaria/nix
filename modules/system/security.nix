{
  # copied from gitlab.com/sofiablahaj/nix, ty :3
  security.pam.loginLimits = [
    {
      domain = "*";
      type = "hard";
      item = "core";
      value = "0";
    } # Disable core dumps
  ];

  boot.kernel.sysctl = {
    # Protection against SYN flood attacks
    "net.ipv4.tcp_syncookies" = true;
    "net.ipv4.tcp_max_syn_backlog" = 2048;

    # Disable IP forwarding and source routing
    "net.ipv4.ip_forward" = false;
    "net.ipv4.conf.all.accept_source_route" = false;
  };
  security.sudo-rs.enable = true;
}
