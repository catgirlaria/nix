{
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        type = "kitty";
        source = "~/nixos/assets/nixowos.png";

        width = 24;

        padding = {
          top = 1;
          right = 4;
        };
      };

      display = {
        separator = "  ";

        key = {
          width = 16;
        };
      };

      modules = [
        "break"
        "break"
        {
          type = "os";
          key = "├─   os";
          keyColor = "magenta";
        }

        {
          type = "host";
          key = "├─ 󰌢  host";
          keyColor = "magenta";
        }

        {
          type = "kernel";
          key = "├─   kernel";
          keyColor = "light_magenta";
        }

        {
          type = "uptime";
          key = "╰─ 󰅐  uptime";
          keyColor = "light_magenta";
        }

        "break"

        # Desktop
        {
          type = "de";
          key = "╭─ 󰧨  desktop";
          keyColor = "cyan";
        }

        {
          type = "wm";
          key = "├─   wm";
          keyColor = "cyan";
        }

        {
          type = "terminal";
          key = "├─   terminal";
          keyColor = "light_cyan";
        }

        {
          type = "shell";
          key = "╰─   shell";
          keyColor = "light_cyan";
        }

        "break"

        # Hardware
        {
          type = "cpu";
          key = "╭─   cpu";
          keyColor = "blue";
        }

        {
          type = "gpu";
          key = "├─ 󰢮  gpu";
          keyColor = "blue";
        }

        {
          type = "memory";
          key = "├─   memory";
          keyColor = "light_blue";
        }

        {
          type = "disk";
          key = "╰─ 󰋊  disk";
          keyColor = "light_blue";
          folders = "/";
        }

        "break"

        # Software
        {
          type = "packages";
          key = "╭─ 󰏖  packages";
          keyColor = "yellow";
        }

        {
          type = "display";
          key = "╰─ 󰹑  display";
          keyColor = "yellow";
        }

        "break"

        {
          type = "colors";
          symbol = "circle";
        }
        "break"
        "break"
      ];
    };
  };

}
