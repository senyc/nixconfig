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
    # sops-nix = {
    #   url = "github:Mic92/sops-nix";
    # };
    home-manager = {
      url = "github:nix-community/home-manager";
    };
    nur = {
      url = "github:nix-community/NUR";
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
    nixosConfigurations = utils.mkHosts ["nixos" "laptop" "work" "basic"];
  };
}
