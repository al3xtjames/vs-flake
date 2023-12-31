{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  nixConfig = {
    extra-substituters = [
      "https://cuda-maintainers.cachix.org"
      "https://vs-flake.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
      "vs-flake.cachix.org-1:bIru8beu4KuF9g1dLgKq5z928m5pSpxIU/ZqwqXlnmQ="
    ];
  };

  outputs = { self, nixpkgs }:
    let
      inherit (nixpkgs) lib;

      systems = [ "x86_64-linux" "x86_64-darwin" ];
      pkgsFor = system: import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          cudaSupport = true;
        };

        overlays = [ self.overlays.default ];
      };

      forEachSystem = systems: f: lib.genAttrs systems (system: f system (pkgsFor system));
      forAllSystems = forEachSystem systems;
    in {
      packages = forAllSystems (system: pkgs:
        let
          python3Packages = pkgs.vapoursynth.python3.pkgs;
          inherit (self.legacyPackages.${system}) vapoursynthPlugins;
        in {
          ass2bdnxml = pkgs.callPackage ./pkgs/ass2bdnxml { };

          dovi_tool = pkgs.callPackage ./pkgs/dovi_tool {
            inherit (pkgs.darwin.apple_sdk_11_0.frameworks) CoreText;
          };

          # Available outside of vapoursynthPlugins as it provides ffmsindex
          ffms = vapoursynthPlugins.ffms;

          getnativef = python3Packages.callPackage ./pkgs/getnativef {
            inherit vapoursynthPlugins;
          };

          hdr10plus_tool = pkgs.callPackage ./pkgs/hdr10plus_tool {
            inherit (pkgs.darwin.apple_sdk_11_0.frameworks) CoreText;
          };

          x265 = pkgs.callPackage ./pkgs/x265 {
            inherit (pkgs.llvmPackages_16) stdenv;
          };

          yuuno = python3Packages.callPackage ./pkgs/yuuno { };
        }
      );

      legacyPackages = forAllSystems (system: pkgs:
        let
          python3Packages = pkgs.vapoursynth.python3.pkgs;
          inherit (self.legacyPackages.${system}) vapoursynthLibs vapoursynthPlugins;
        in {
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

            dvdsrc2 = pkgs.callPackage ./pkgs/vapoursynth-plugins/dvdsrc2 { };

            eedi2 = pkgs.callPackage ./pkgs/vapoursynth-plugins/eedi2 { };

            eedi2cuda = pkgs.callPackage ./pkgs/vapoursynth-plugins/eedi2cuda { };

            eedi3 = pkgs.callPackage ./pkgs/vapoursynth-plugins/eedi3 { };

            ffms = (pkgs.ffms.overrideAttrs {
              version = "unstable-2023-10-12";
              src = pkgs.fetchFromGitHub {
                owner = "FFMS";
                repo = "ffms2";
                rev = "f20827cf280b669321cd5b62e01d744bc68c21fc";
                hash = "sha256-Ec9A8jD4lj5hIJ5qwzOzVLBI8bzW4AP8Mx1//XP1V18=";
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

            sneedif = pkgs.callPackage ./pkgs/vapoursynth-plugins/sneedif { };

            subtext = pkgs.callPackage ./pkgs/vapoursynth-plugins/subtext { };

            tcanny = pkgs.callPackage ./pkgs/vapoursynth-plugins/tcanny { };

            tedgemask = pkgs.callPackage ./pkgs/vapoursynth-plugins/tedgemask { };

            temporalmedian = pkgs.callPackage ./pkgs/vapoursynth-plugins/temporalmedian { };

            tivtc = pkgs.callPackage ./pkgs/vapoursynth-plugins/tivtc { };

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

              vsdehalo = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsdehalo {
                inherit vapoursynthPlugins;
              };

              vsdeinterlace = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsdeinterlace {
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

              vssource = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vssource {
                inherit vapoursynthPlugins;
              };

              vstaambk = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vstaambk {
                inherit vapoursynthPlugins;
              };

              vstools = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vstools { };

              vsutil = python3Packages.callPackage ./pkgs/vapoursynth-plugins/python-modules/vsutil { };
            };
          };
        }
      );

      devShells = forAllSystems (system: pkgs:
        let
          selfPackages = self.packages.${system};
          inherit (self.legacyPackages.${system}) vapoursynthPlugins;
          allPackages = lib.filter
            (x: lib.attrsets.isDerivation x && x != selfPackages.yuuno)
            (lib.attrValues selfPackages);

          allPlugins = lib.filter
            (x: lib.attrsets.isDerivation x)
            (lib.attrValues vapoursynthPlugins) ++
            lib.attrValues vapoursynthPlugins.pythonModules;
        in {
          default = pkgs.mkShell {
            buildInputs = with pkgs; allPackages ++ [
              (vapoursynth.withPlugins allPlugins)
              (selfPackages.yuuno.withPlugins allPlugins)
              ffmpeg_6
            ];
          };
        }
      );

      overlays.default = (final: prev: {
        pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
          (python-final: python-prev: {
            stgpytools = python-final.callPackage ./pkgs/python3/stgpytools { };

            # overridePythonAttrs isn't used as it doesn't appear to pass
            # passthru attributes.
            vapoursynth = python-final.callPackage ./pkgs/python3/vapoursynth {
              inherit (prev) vapoursynth;
            };
          })
        ];
      });
    };
}
