{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vsfilterscript";
  version = "stable";

  src = fetchFromGitHub {
    owner = "IFeelBloated";
    repo = "vapoursynth-plusplus";
    rev = version;
    hash = "sha256-xatZsa+3b2P3ubeUfViDBRhjFroLvu/ciyxqI1tBZ64=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  meta = with lib; {
    description = "Vaporsynth C++ API";
    homepage = "https://github.com/IFeelBloated/vapoursynth-plusplus";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
