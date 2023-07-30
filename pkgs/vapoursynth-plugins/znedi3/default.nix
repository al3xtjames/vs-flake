{ lib
, stdenv
, fetchFromGitHub
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-znedi3";
  version = "unstable-2023-07-09";

  src = fetchFromGitHub {
    owner = "sekrit-twc";
    repo = "znedi3";
    rev = "68dc130bc37615fd912d1dc1068261f00f54b146";
    hash = "sha256-QC+hMMfp6XwW4PqsN6sip1Y7ttiYn/xuxq/pUg/trog=";
    fetchSubmodules = true;
  };

  makeFlags = lib.optional stdenv.hostPlatform.isx86_64 [
    "X86=1"
    "X86_AVX512=1"
  ];

  enableParallelBuilding = true;

  installPhase = ''
    runHook preInstall

    install -D nnedi3_weights.bin $out/lib/vapoursynth/nnedi3_weights.bin
    install -D vsznedi3${ext} $out/lib/vapoursynth/vsznedi3${ext}

    runHook postInstall
  '';

  meta = with lib; {
    description = "CPU-optimized version of nnedi";
    homepage = "https://github.com/sekrit-twc/znedi3";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
