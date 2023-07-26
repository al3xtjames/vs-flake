{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, which
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bilateral";
  version = "unstable-2015-06-29";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "5c246c08914661fa2711eba5b7e8ca383bf0b717";
    hash = "sha256-whnL4U+kwv0m9jWkXIUYhnZ2BAn05IugfBZj9lGupyI=";
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    vapoursynth
  ];

  dontAddPrefix = true;

  configureFlags = [
    "--install=${placeholder "out"}/lib/vapoursynth"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Bilateral filter for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/VapourSynth-Bilateral";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
