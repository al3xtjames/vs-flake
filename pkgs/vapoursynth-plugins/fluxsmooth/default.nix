{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fluxsmooth";
  version = "2";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-u12XjXOZCasgQtrxtuAjFxYaziMCWFNK0rqV5qM/Qnw=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  configureFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A filter for smoothing of fluctuations";
    homepage = "https://github.com/dubhater/vapoursynth-fluxsmooth";
    license = licenses.unfree; # no license?
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
