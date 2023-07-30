{ lib
, stdenv
, fetchFromGitHub
, meson
, nasm
, ninja
, pkg-config
, fftwFloat
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-mvtools";
  version = "unstable-2023-01-17";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "d2c491b3030415c4b416f048e236f5f327d7cb89";
    hash = "sha256-cfYejh1FqdKeUnYNoMJhhW0kODjTfDfBc74+wrCgoH0=";
  };

  nativeBuildInputs = [
    meson
    nasm
    ninja
    pkg-config
  ];

  buildInputs = [
    fftwFloat
    vapoursynth
  ];

  preConfigure = ''
    export AR=${stdenv.cc.targetPrefix}gcc-ar
  '';

  mesonFlags = [
    "--libdir=${placeholder "out"}/lib/vapoursynth"
  ];

  meta = with lib; {
    description = "Set of filters for motion estimation and compensation";
    homepage = "https://github.com/dubhater/vapoursynth-mvtools";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
