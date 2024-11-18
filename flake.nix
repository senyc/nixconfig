{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    neovim-config = {
      url = "github:senyc/nvimconfig";
    };
    disko = {
      url = "github:nix-community/disko";
    };
    ags = {
      url = "github:Aylur/ags/60180a184cfb32b61a1d871c058b31a3b9b0743d";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
  };
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (self) outputs;
    utils = import ./nix/utils.nix {inherit inputs outputs;};
  in {
    overlays = import ./nix/overlays.nix {inherit inputs outputs;};
    # nixos is the equivalent of "default" in that it is invoked by not specifying a host
    nixosConfigurations = utils.mkHosts ["nixos" "laptop" "work"];
  };
}
