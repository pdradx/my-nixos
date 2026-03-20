{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-25.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, ... }@inputs: 
  let 
    system = "x86_64-linux";
    pkgs-unstable = import nixpkgs-unstable {
        inherit system;
	config.allowUnfree = true;
    };
  in {
    # Please replace my-nixos with your hostname
    nixosConfigurations.ntrn-p1g8 = nixpkgs.lib.nixosSystem {
      # Set all inputs parameters as special arguments for all submodules,
      # so you can directly use all dependencies in inputs in submodules
      specialArgs = { inherit pkgs-unstable; };

      modules = [
        # Import the previous configuration.nix we used,
        # so the old configuration file still takes effect
        ./configuration.nix
      ];
    };
  };
}
