{
    description = "NixOS from Scratch";
    inputs = {
        nixpkgs.url = "nixpkgs/nixos-26.05";
        waybar = {
          url = "github:Alexays/Waybar";
          inputs.nixpkgs.follows = "nixpkgs";   # 建议加，避免多下载一套 nixpkgs
        };
        home-manager = {
            url = "github:nix-community/home-manager/release-26.05";
            inputs.nixpkgs.follows = "nixpkgs";
        };
        self.submodules = true;
    };

    outputs = { self, nixpkgs, waybar, home-manager, ... }: {
        nixosConfigurations = {
          nixos-btw = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              specialArgs = { inherit waybar; };
              modules = [
                  ./hosts/nixos-btw
                  home-manager.nixosModules.home-manager
                  {
                      home-manager = {
                          useGlobalPkgs = true;
                          useUserPackages = true;
                          users.light = import ./home.nix;
                          backupFileExtension = "backup";
                      };
                  }
              ];
          };
        };
    };
}

