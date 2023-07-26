{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-awarpsharp2";
  version = "4";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-wB70gj/WJf+/vLteO05dawPPnvr/22FsDWHOYooF35g=";
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
    description = "Sharpens edges by warping them";
    homepage = "https://github.com/dubhater/vapoursynth-awarpsharp2";
    license = licenses.isc;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
