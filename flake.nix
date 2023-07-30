{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [ "x86_64-linux" ];
      pkgsFor = system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };
      };

      forEachSystem = systems: f: lib.genAttrs systems (system: f system (pkgsFor system));
      forAllSystems = forEachSystem systems;
    in {
      packages = forAllSystems (system: pkgs:
        let
          selfPackages = self.packages.${system};
          python3Packages = pkgs.vapoursynth.python3.pkgs;

          inherit (selfPackages) vapoursynthLibs vapoursynthPlugins;
        in {
          # Available outside of vapoursynthPlugins as it provides ffmsindex
          ffms = vapoursynthPlugins.ffms;

          getnative = python3Packages.callPackage ./pkgs/getnative {
            inherit vapoursynthPlugins;
          };

          yuuno = python3Packages.callPackage ./pkgs/yuuno { };

          vapoursynthLibs = {
            vsfilterscript = pkgs.callPackage ./pkgs/vapoursynth-libs/vsfilterscript { };
          };

          vapoursynthPlugins = {
            adaptivegrain = pkgs.callPackage ./pkgs/vapoursynth-plugins/adaptivegrain { };

            addgrain = pkgs.callPackage ./pkgs/vapoursynth-plugins/addgrain { };

            addnoise = pkgs.callPackage ./pkgs/vapoursynth-plugins/addnoise { };

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

            chickendream = pkgs.callPackage ./pkgs/vapoursynth-plugins/chickendream { };

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

            fgrain-cuda = pkgs.callPackage ./pkgs/vapoursynth-plugins/fgrain-cuda { };

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

            mvtools-sf = pkgs.callPackage ./pkgs/vapoursynth-plugins/mvtools-sf {
              inherit (vapoursynthLibs) vsfilterscript;
            };

            neo-f3kdb = pkgs.callPackage ./pkgs/vapoursynth-plugins/neo-f3kdb { };

            nlm-cuda = pkgs.callPackage ./pkgs/vapoursynth-plugins/nlm-cuda { };

            nlq = pkgs.callPackage ./pkgs/vapoursynth-plugins/nlq { };

            nnedi3cl = pkgs.callPackage ./pkgs/vapoursynth-plugins/nnedi3cl { };

            placebo = pkgs.callPackage ./pkgs/vapoursynth-plugins/placebo { };

            remapframes = pkgs.callPackage ./pkgs/vapoursynth-plugins/remapframes { };

            removegrain = pkgs.callPackage ./pkgs/vapoursynth-plugins/removegrain { };

            removegrain-sf = pkgs.callPackage ./pkgs/vapoursynth-plugins/removegrain-sf { };

            sangnom = pkgs.callPackage ./pkgs/vapoursynth-plugins/sangnom { };

            subtext = pkgs.callPackage ./pkgs/vapoursynth-plugins/subtext { };

            tcanny = pkgs.callPackage ./pkgs/vapoursynth-plugins/tcanny { };

            tedgemask = pkgs.callPackage ./pkgs/vapoursynth-plugins/tedgemask { };

            temporalmedian = pkgs.callPackage ./pkgs/vapoursynth-plugins/temporalmedian { };

            tmaskcleaner = pkgs.callPackage ./pkgs/vapoursynth-plugins/tmaskcleaner { };

            trt = pkgs.callPackage ./pkgs/vapoursynth-plugins/trt { };

            ttempsmooth = pkgs.callPackage ./pkgs/vapoursynth-plugins/ttempsmooth { };

            wnnm = pkgs.callPackage ./pkgs/vapoursynth-plugins/wnnm { };

            znedi3 = pkgs.callPackage ./pkgs/vapoursynth-plugins/znedi3 { };

            pythonModules = {
              adjust = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/adjust { };

              awsmfunc = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/awsmfunc {
                inherit vapoursynthPlugins;
              };

              cooldegrain = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/cooldegrain {
                inherit vapoursynthPlugins;
              };

              descale = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/descale {
                inherit vapoursynthPlugins;
              };

              dfttest2 = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/dfttest2 {
                inherit vapoursynthPlugins;
              };

              hardaap2 = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/hardaap2 {
                inherit vapoursynthPlugins;
              };

              havsfunc = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/havsfunc {
                inherit vapoursynthPlugins;
              };

              muvsfunc = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/muvsfunc {
                inherit vapoursynthPlugins;
              };

              mvsfunc = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/mvsfunc {
                inherit vapoursynthPlugins;
              };

              nnedi3-resample = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/nnedi3-resample {
                inherit vapoursynthPlugins;
              };

              rekt = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/rekt {
                inherit vapoursynthPlugins;
              };

              vsaa = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsaa {
                inherit vapoursynthPlugins;
              };

              vsdeband = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsdeband {
                inherit vapoursynthPlugins;
              };

              vsdenoise = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsdenoise {
                inherit vapoursynthPlugins;
              };

              vsexprtools = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsexprtools {
                inherit vapoursynthPlugins;
              };

              vskernels = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vskernels {
                inherit vapoursynthPlugins;
              };

              vsmasktools = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsmasktools {
                inherit vapoursynthPlugins;
              };

              vsmlrt = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsmlrt {
                inherit vapoursynthPlugins;
              };

              vspyplugin = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vspyplugin {
                inherit vapoursynthPlugins;
              };

              vsrgtools = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsrgtools {
                inherit vapoursynthPlugins;
              };

              vsscale = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsscale {
                inherit vapoursynthPlugins;
              };

              vstools = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vstools { };

              vsutil = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsutil { };

              vstaambk = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vstaambk {
                inherit vapoursynthPlugins;
              };
            };
          };
        }
      );

      devShells = forAllSystems (system: pkgs:
        let
          selfPackages = self.packages.${system};
          allPackages = lib.filter
            (x: lib.attrsets.isDerivation x && x != selfPackages.yuuno)
            (lib.attrValues selfPackages);

          allPlugins = lib.filter
            (x: lib.attrsets.isDerivation x)
            (lib.attrValues selfPackages.vapoursynthPlugins) ++
            lib.attrValues selfPackages.vapoursynthPlugins.pythonModules;
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; allPackages ++ [
              (vapoursynth.withPlugins allPlugins)
              (selfPackages.yuuno.withPlugins allPlugins)
            ];
          };
        }
      );
    };
}
