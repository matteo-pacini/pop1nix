{
  description = "Prince Of Persia Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
  };

  outputs =
    { self, nixpkgs }:
    let
      lib = nixpkgs.lib;
      forAllSystems = lib.genAttrs lib.platforms.unix;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgsFor."${system}";
        in
        {
          pop1 = pkgs.callPackage ./packages/pop1 { };
        }
      );

      apps = forAllSystems (
        system:
        let
          pop1 = self.packages."${system}".pop1;
        in
        {
          pop1 = {
            type = "app";
            program = "${pop1}/bin/pop1";
          };
        }
      );
    };
}
