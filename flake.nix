{
  description = "NixOS image for GCE";

  inputs = {
    nixpkgs.url        = "github:nixos/nixpkgs";
    flake-utils.url    = "github:numtide/flake-utils";
    flake-compat.url   = "github:edolstra/flake-compat";
    flake-compat.flake = false;
  };

  outputs = { self, nixpkgs, flake-utils, flake-compat }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        name = "sga";
        version = "0.1.0";
        revision = "${self.lastModifiedDate}-${self.shortRev or "dirty"}";
        pkgs = nixpkgs.legacyPackages.${system};
        gdk  = pkgs.google-cloud-sdk.withExtraComponents( with pkgs.google-cloud-sdk.components;
          [ gke-gcloud-auth-plugin ]
        );
      in {
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            bashInteractive
            cacert
            gdk
            gawk
            gnumake
            google-cloud-sdk
          ];
          shellHook = ''
            export LANG=en_US.UTF-8
            export SHELL=$BASH
            export PYTHONPATH=$(pwd)/src:$PYTHONPATH
            export PS1="nixos-gce|$PS1"
            alias gc=gcloud
          '';
        };
      }
    );
}
