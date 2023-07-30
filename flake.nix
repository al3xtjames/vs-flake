{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        selfPackages = self.packages.${system};
        inherit (selfPackages) vapoursynthPlugins;
      in
      {
        packages = {
          # Available outside of vapoursynthPlugins as it provides ffmsindex
          ffms = vapoursynthPlugins.ffms;

          vapoursynthPlugins = {
            adaptivegrain = pkgs.callPackage ./pkgs/vapoursynth-plugins/adaptivegrain { };

            addgrain = pkgs.callPackage ./pkgs/vapoursynth-plugins/addgrain { };

            akarin = pkgs.callPackage ./pkgs/vapoursynth-plugins/akarin { };

            awarpsharp2 = pkgs.callPackage ./pkgs/vapoursynth-plugins/awarpsharp2 { };

            awarpsharp2-sf = pkgs.callPackage ./pkgs/vapoursynth-plugins/awarpsharp2-sf { };

            bestsource = pkgs.callPackage ./pkgs/vapoursynth-plugins/bestsource { };

            bilateral = pkgs.callPackage ./pkgs/vapoursynth-plugins/bilateral { };

            bm3d = pkgs.callPackage ./pkgs/vapoursynth-plugins/bm3d { };

            bm3dcuda = pkgs.callPackage ./pkgs/vapoursynth-plugins/bm3dcuda { };

            bmdegrain = pkgs.callPackage ./pkgs/vapoursynth-plugins/bmdegrain { };

            bwdif = pkgs.callPackage ./pkgs/vapoursynth-plugins/bwdif { };

            cas = pkgs.callPackage ./pkgs/vapoursynth-plugins/cas { };

            ctmf = pkgs.callPackage ./pkgs/vapoursynth-plugins/ctmf { };

            dctfilter = pkgs.callPackage ./pkgs/vapoursynth-plugins/dctfilter { };

            deblock = pkgs.callPackage ./pkgs/vapoursynth-plugins/deblock { };

            descale = pkgs.callPackage ./pkgs/vapoursynth-plugins/descale { };

            dfttest = pkgs.callPackage ./pkgs/vapoursynth-plugins/dfttest { };

            dfttest2 = pkgs.callPackage ./pkgs/vapoursynth-plugins/dfttest2 { };

            dpid = pkgs.callPackage ./pkgs/vapoursynth-plugins/dpid { };

            eedi2 = pkgs.callPackage ./pkgs/vapoursynth-plugins/eedi2 { };

            eedi2cuda = pkgs.callPackage ./pkgs/vapoursynth-plugins/eedi2cuda { };

            eedi3 = pkgs.callPackage ./pkgs/vapoursynth-plugins/eedi3 { };

            ffms = (pkgs.ffms.overrideAttrs {
              version = "unstable-2023-07-22";
              src = pkgs.fetchFromGitHub {
                owner = "FFMS";
                repo = "ffms2";
                rev = "ef243ab40b8d4b6d18874c6cef0da1a2f55a6a45";
                hash = "sha256-w2rkHYOMyBMA8tdAoBtRkMvxrNXYuUbXJ4aimQXkl5w=";
              };
            }).override {
              ffmpeg_4 = pkgs.ffmpeg_6;
            };

            fft3dfilter = pkgs.callPackage ./pkgs/vapoursynth-plugins/fft3dfilter { };

            fillborders = pkgs.callPackage ./pkgs/vapoursynth-plugins/fillborders { };

            fluxsmooth = pkgs.callPackage ./pkgs/vapoursynth-plugins/fluxsmooth { };

            fmtconv = pkgs.callPackage ./pkgs/vapoursynth-plugins/fmtconv { };

            fpng = pkgs.callPackage ./pkgs/vapoursynth-plugins/fpng { };

            hqdn3d = pkgs.callPackage ./pkgs/vapoursynth-plugins/hqdn3d { };

            imwri = pkgs.callPackage ./pkgs/vapoursynth-plugins/imwri { };

            knlmeanscl = pkgs.callPackage ./pkgs/vapoursynth-plugins/knlmeanscl { };

            miscfilters-obsolete = pkgs.callPackage ./pkgs/vapoursynth-plugins/miscfilters-obsolete { };

            # Upstream switched to meson, which is why this isn't an override
            mvtools = pkgs.callPackage ./pkgs/vapoursynth-plugins/mvtools { };

            neo-f3kdb = pkgs.callPackage ./pkgs/vapoursynth-plugins/neo-f3kdb { };

            nlm-cuda = pkgs.callPackage ./pkgs/vapoursynth-plugins/nlm-cuda { };

            nlq = pkgs.callPackage ./pkgs/vapoursynth-plugins/nlq { };

            nnedi3cl = pkgs.callPackage ./pkgs/vapoursynth-plugins/nnedi3cl { };

            placebo = pkgs.callPackage ./pkgs/vapoursynth-plugins/placebo { };

            remapframes = pkgs.callPackage ./pkgs/vapoursynth-plugins/remapframes { };
          };
        };
      }
    );
}
