{
  description = "NixOS + Home Manager + Hyprland (autologin + hyprlock)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      mkHost = { hostName, system, user }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            home-manager.nixosModules.home-manager

            ./modules/hyprland.nix
	    ./modules/flatpak.nix
            ./hosts/${hostName}/hardware-configuration.nix
            ./hosts/${hostName}/configuration.nix
            # Home Manager wiring
            ({ ... }: {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.${user} = import ./home/${user}/home.nix;
            })
          ];
          specialArgs = { inherit user; };
        };
    in
    {
      nixosConfigurations = {
        vm = mkHost { hostName = "vm"; system = "x86_64-linux"; user = "lukas"; };
        t480 = mkHost { hostName = "t480"; system = "x86_64-linux"; user = "lukas"; };
      };
    };
}
