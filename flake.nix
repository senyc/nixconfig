{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    gBar = {
      url = "github:scorpion-26/gBar";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-config = {
      url = "github:senyc/nvimconfig";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags.url = "github:Aylur/ags";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
