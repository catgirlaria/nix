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
  };
  outputs = { self, nixpkgs, ... }@inputs:
    let
      glob = rec {
        HOSTNAME = "delusion";
        TZ = "America/Chicago";
        LOCALE = "en_US.UTF-8";
        USER = "aria";
      };
      # doesn't need to be global var
      HOST_DIR = ./hosts/${glob.HOSTNAME};
    in {
    nixosConfigurations.${glob.HOSTNAME} = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = { inherit inputs glob; };

      modules = [
        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [ inputs.plasma-manager.homeModules.plasma-manager ];
          home-manager.extraSpecialArgs = { inherit inputs glob; };
          home-manager.backupFileExtension = "bak";
          home-manager.users.${glob.USER} = ./users/${glob.USER}/home.nix;
        }
        inputs.chaotic.nixosModules.default
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.default
        (HOST_DIR + "/config.nix")
        (HOST_DIR + "/preservation.nix")
        (HOST_DIR + "/disko.nix")
      ];
    };
  };
}

