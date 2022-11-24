{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    bombon.url = "github:henrirosten/bombon";
    bombon.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, bombon }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      # target = ( pkgs.hello );
      target = ( import ../nix-hello/default.nix );
    in
    {
      packages.${system}.default = bombon.lib.${system}.buildBom target;
    };
}
