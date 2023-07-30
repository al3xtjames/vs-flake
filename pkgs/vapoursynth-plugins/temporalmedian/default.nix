{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-temporalmedian";
  version = "1";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-UMYBA0kAGiNdcacV25O0pFgbt8bYbhS19u6edZfugYE=";
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
    description = "Calculates temporal median";
    longDescription = ''
      TemporalMedian is a temporal denoising filter.
      It replaces every pixel with the median of its temporal neighbourhood.
    '';
    homepage = "https://github.com/dubhater/vapoursynth-temporalmedian";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
