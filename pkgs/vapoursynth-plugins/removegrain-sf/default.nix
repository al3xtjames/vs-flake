{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, vapoursynth
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-removegrain-sf";
  version = "5";

  src = fetchFromGitHub {
    owner = "IFeelBloated";
    repo = "RGSF";
    rev = "r${version}";
    hash = "sha256-/w4z8cv4cl+6e8n+fA9axIRVuDo6gFahxM4Rghkpbv0=";
  };

  postPatch = ''
    rm VSHelper.h VapourSynth.h
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  buildPhase = ''
    runHook preBuild

    $CXX -o librgsf${ext} -shared -fPIC -O2 $(pkg-config --cflags vapoursynth) \
      Clense.cpp RGVS.cpp RemoveGrain.cpp Repair.cpp VerticalCleaner.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D librgsf${ext} $out/lib/vapoursynth/librgsf${ext}

    runHook postInstall
  '';

  meta = with lib; {
    description = "RGVS Single Precision";
    homepage = "https://github.com/IFeelBloated/RGSF";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
