{
  description = "Delusion flake (codeberg.org/catgirlaria/nix)";

  inputs = {
    # This is pointing to an unstable release.
    # If you prefer a stable release instead, you can change the word unstable to the latest number shown here: https://nixos.org/download
    # i.e. nixos-24.11
    # Use `nix flake update` to update the flake to the latest revision of the chosen release channel.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    preservation.url = "github:nix-community/preservation";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    import-tree.url = "github:denful/import-tree";
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # BLAZINGLY FAST 🔥🔥🔥🔥🔥
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixowos = {
      url = "github:yunfachi/nixowos";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixcord.url = "github:4evy/nixcord";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
  outputs =
    { nixpkgs, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      glob = {
        HOSTNAME = "delusion";
        TZ = "America/Chicago";
        LOCALE = "en_US.UTF-8";
        USER = "aria";
      };
      # doesn't need to be global var
      HOST_DIR = ./hosts/${glob.HOSTNAME};
      preCommit = inputs.git-hooks.lib.${system}.run {
        src = ./.;

        hooks = {
          nixfmt.enable = true;

          # nice extras
          statix.enable = true;
          deadnix.enable = true;
        };
      };
    in
    {
      checks.${system}.pre-commit-check = preCommit;
      devShells.${system}.default = pkgs.mkShell {
        inherit (preCommit) shellHook;
        buildInputs = preCommit.enabledPackages;
      };
      nixosConfigurations.${glob.HOSTNAME} = nixpkgs.lib.nixosSystem {

        specialArgs = { inherit inputs glob; };

        modules = [
          inputs.home-manager.nixosModules.home-manager
          inputs.nixowos.nixosModules.default
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                inputs.nixowos.homeModules.default
                inputs.plasma-manager.homeModules.plasma-manager
                inputs.nixcord.homeModules.nixcord
              ];
              extraSpecialArgs = { inherit inputs glob; };
              backupFileExtension = "bak";
              users.${glob.USER} = ./users/${glob.USER}/home.nix;
            };
          }
          inputs.chaotic.nixosModules.default
          inputs.disko.nixosModules.disko
          inputs.preservation.nixosModules.default
          inputs.nix-flatpak.nixosModules.nix-flatpak
          (HOST_DIR + "/config.nix")
          (HOST_DIR + "/preservation.nix")
          (HOST_DIR + "/disko.nix")
        ];
      };
    };
}
