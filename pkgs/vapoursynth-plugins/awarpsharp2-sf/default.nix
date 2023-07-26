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
  pname = "vapoursynth-awarpsharp2-sf";
  version = "1";

  src = fetchFromGitHub {
    owner = "IFeelBloated";
    repo = "warpsharp";
    rev = "r${version}";
    hash = "sha256-ar3Dg7SpW42AEZy3H9lnj9oNQO70e6M/s+TDvcofFCg=";
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

    $CXX -o libwarpsf${ext} -shared -fPIC -O2 $(pkg-config --cflags vapoursynth) \
      Source.cpp

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -D libwarpsf${ext} $out/lib/vapoursynth/libwarpsf${ext}

    runHook postInstall
  '';

  meta = with lib; {
    description = "fp32 warpsharp for vaporsynth";
    homepage = "https://github.com/IFeelBloated/warpsharp";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
