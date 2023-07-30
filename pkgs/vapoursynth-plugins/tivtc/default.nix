{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-tivtc";
  version = "unstable-2021-03-19";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "1713095068d18a2fe93598aaabd7e53e12163e03";
    hash = "sha256-jHpy+z8Qg2AAyR3pLE+aNX5aFIiW6yDXZanld3pHiyk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  mesonFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  meta = with lib; {
    description = "Field matching and decimation filters (inverse telecine)";
    homepage = "https://github.com/dubhater/vapoursynth-tivtc";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
