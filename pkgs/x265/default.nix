{ lib
, stdenv
, fetchFromBitbucket
, fetchpatch
, fetchzip
, cmake
, ffmpeg
, nasm

# NUMA support enabled by default on NUMA platforms:
, numaSupport ? (stdenv.hostPlatform.isLinux && (stdenv.hostPlatform.isx86 || stdenv.hostPlatform.isAarch64))
, numactl

# Multi bit-depth support (8bit+10bit+12bit):
, multibitdepthSupport ? (stdenv.is64bit && !(stdenv.isAarch64 && stdenv.isLinux))

# Other options:
, cliSupport ? true # Build standalone CLI application
, custatsSupport ? false # Internal profiling of encoder work
, debugSupport ? false # Run-time sanity checks (debugging)
, ppaSupport ? false # PPA profiling instrumentation
, unittestsSupport ? stdenv.isx86_64 # Unit tests - only testing x64 assembly
, vtuneSupport ? false # Vtune profiling instrumentation
, werrorSupport ? false # Warnings as errors
, ltoSupport ? false # Enable link-time optimization
, pgoSupport ? false # Enable profile-guided optimization
}:

let
  mkFlag = optSet: flag: if optSet then "-D${flag}=ON" else "-D${flag}=OFF";

  isCross = stdenv.buildPlatform != stdenv.hostPlatform;

  cmakeCommonFlags = [
    "-Wno-dev"
    (mkFlag custatsSupport "DETAILED_CU_STATS")
    (mkFlag debugSupport "CHECKED_BUILD")
    (mkFlag ppaSupport "ENABLE_PPA")
    (mkFlag vtuneSupport "ENABLE_VTUNE")
    (mkFlag werrorSupport "WARNINGS_AS_ERRORS")
    # Potentially riscv cross could be fixed by providing the correct CMAKE_SYSTEM_PROCESSOR flag
  ] ++ lib.optional (isCross && stdenv.hostPlatform.isRiscV) "-DENABLE_ASSEMBLY=OFF";

  cmakeStaticLibFlags = [
    "-DHIGH_BIT_DEPTH=ON"
    "-DENABLE_CLI=OFF"
    "-DENABLE_SHARED=OFF"
    "-DEXPORT_C_API=OFF"
  ] ++ lib.optionals stdenv.hostPlatform.isPower [
    "-DENABLE_ALTIVEC=OFF" # https://bitbucket.org/multicoreware/x265_git/issues/320/fail-to-build-on-power8-le
  ];

  bigBuckBunny = fetchzip {
    url = "https://mirrors.ocf.berkeley.edu/blender/demo/movies/BBB/bbb_sunflower_1080p_30fps_normal.mp4.zip";
    hash = "sha256-By/bBVwhx1998NxPc80s19IBc/iJeDQVYT5RDKP94Qk=";
  };
in
stdenv.mkDerivation rec {
  pname = "x265";
  version = "3.5-151-g8ee01d45b";

  outputs = [ "out" "dev" ];

  src = fetchFromBitbucket {
    owner = "multicoreware";
    repo = "x265_git";
    rev = version;
    hash = "sha256-tAx9qJvpmi64snQEiNtuZQMSVXlex3YtHsCw5lGUQPQ=";
  };

  sourceRoot = "source/source";

  patches = [
    # More aliases for ARM platforms + do not force CLFAGS for ARM :
    (fetchpatch {
      url = "https://raw.githubusercontent.com/gentoo/gentoo/9591e8238da4f5ddab702a01f93fba05943f2a0d/media-libs/x265/files/x265-9999-arm.patch";
      hash = "sha256-p0BUv+/giozEelzKAQzhb+mgOiD613HzNcCS3XwsM9c=";
    })
    # Namespace functions for multi-bitdepth builds so that libraries are self-contained (and tests succeeds) :
    (fetchpatch {
      url = "https://gist.githubusercontent.com/al3xtjames/220e977fa4c269596407ab1e3e38558b/raw/218f043f6e36abeb8dd0eea52723f5bd24b0852f/test-ns.patch";
      hash = "sha256-MYcGYjyKodaoBlxY7FxEadmQu/xqKLJTXddB+BGqyKI=";
    })
    ./include-x86intrin-on-darwin.patch
  ];

  postPatch = ''
    cat << EOF > cmake/Version.cmake
    set(X265_VERSION "${version}+${toString (builtins.length patches)}")
    set(X265_LATEST_TAG "${builtins.head (lib.splitString "-" version)}")
    set(X265_TAG_DISTANCE "${builtins.elemAt (lib.splitString "-" version) 1}")
    EOF
  '';

  nativeBuildInputs = [ cmake nasm ] ++ lib.optionals (numaSupport) [ numactl ];

  preConfigurePhases = lib.optionals pgoSupport [
    "configurePhase"
    "buildPhase"
    "profilingPhase"
  ];

  # Builds 10bits and 12bits static libs on the side if multi bit-depth is wanted
  # (we are in x265_<version>/source/build)
  preBuild = lib.optionalString (multibitdepthSupport) ''
    cmake -S ../ -B ../build-10bits ${toString cmakeCommonFlags} ${toString cmakeStaticLibFlags}
    make -C ../build-10bits -j $NIX_BUILD_CORES
    cmake -S ../ -B ../build-12bits ${toString cmakeCommonFlags} ${toString cmakeStaticLibFlags} -DMAIN12=ON
    make -C ../build-12bits -j $NIX_BUILD_CORES
    ln -s ../build-10bits/libx265.a ./libx265-10.a
    ln -s ../build-12bits/libx265.a ./libx265-12.a
  '';

  LDFLAGS = toString (lib.optionals ltoSupport [
    "-flto"
  ] ++ lib.optionals pgoSupport [
    "-fprofile-dir=profdata"
  ]);

  cmakeFlags = cmakeCommonFlags ++ [
    "-DGIT_ARCHETYPE=1" # https://bugs.gentoo.org/814116
    "-DENABLE_SHARED=${if stdenv.hostPlatform.isStatic then "OFF" else "ON"}"
    "-DHIGH_BIT_DEPTH=OFF"
    "-DENABLE_HDR10_PLUS=ON"
    (mkFlag (isCross && stdenv.hostPlatform.isAarch) "CROSS_COMPILE_ARM")
    (mkFlag cliSupport "ENABLE_CLI")
    (mkFlag unittestsSupport "ENABLE_TESTS")
  ] ++ lib.optionals (multibitdepthSupport) [
    "-DEXTRA_LIB=x265-10.a;x265-12.a"
    "-DEXTRA_LINK_FLAGS=-L."
    "-DLINKED_10BIT=ON"
    "-DLINKED_12BIT=ON"
  ];

  preConfigure = lib.optionalString pgoSupport ''
    if [ ! -d profdata ]; then
      mkdir profdata
      cmakeFlagsArray+=(
        "-DFPROFILE_GENERATE=ON"
      )
    else
      for i in "''${!cmakeFlagsArray[@]}"; do
        if [[ ''${cmakeFlagsArray[i]} = "-DFPROFILE_GENERATE=ON" ]]; then
          unset 'cmakeFlagsArray[i]'
        fi
      done

      cmakeFlagsArray+=(
        "-DFPROFILE_USE=ON"
      )
    fi
  '';

  profilingPhase = ''
    ${ffmpeg}/bin/ffmpeg -i ${bigBuckBunny}/bbb_sunflower_1080p_30fps_normal.mp4 \
      -f yuv4mpegpipe - | ./x265 --pools $NIX_BUILD_CORES --y4m --input-depth 8 \
      --profile main10 --level-idc 5.1 --vbv-bufsize 160000 --vbv-maxrate 160000 \
      --preset veryslow --no-open-gop --no-cutree --no-sao --rc-lookahead 60 \
      --ref 6 --bframes 16 --subme 5 --rskip 0 --no-strong-intra-smoothing \
      --qcomp 0.70 --aq-mode 3 --aq-strength 0.80 --psy-rd 2.00 \
      --psy-rdoq 2.00 --deblock -1:-1 --crf 20 -o /dev/null -

    make clean
    rm *.a
    cd ..
  '';

  doCheck = unittestsSupport;
  checkPhase = ''
    runHook preCheck
    ./test/TestBench
    runHook postCheck
  '';

  postInstall = ''
    rm -f ${placeholder "out"}/lib/*.a
  '';

  meta = with lib; {
    description = "Library for encoding H.265/HEVC video streams";
    homepage    = "https://www.x265.org/";
    changelog   = "https://x265.readthedocs.io/en/master/releasenotes.html";
    license     = licenses.gpl2Plus;
    maintainers = with maintainers; [ codyopel ];
    platforms   = platforms.all;
  };
}
