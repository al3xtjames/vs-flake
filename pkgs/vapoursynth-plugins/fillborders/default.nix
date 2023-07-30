{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fillborders";
  version = "unstable-2021-06-13";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "78fe68044fe3414ce8061bf811a235e29c8f7d9d";
    hash = "sha256-mAeFVG9Mi7AIubRdakhJJIdRtXmT0b5YXpEWp4me6uI=";
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
    description = "Fills the borders of a clip";
    homepage = "https://github.com/dubhater/vapoursynth-fillborders";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
