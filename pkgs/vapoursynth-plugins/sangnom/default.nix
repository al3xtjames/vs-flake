{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-sangnom";
  version = "42";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-2lEnwms2wSOyMRmasRG1r8iPAFmBObP6pDzPIinJLz0=";
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
    description = "VapourSynth Single Field Deinterlacer";
    homepage = "https://github.com/dubhater/vapoursynth-sangnom";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
