{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-descale";
  version = "unstable-2023-11-08";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-descale";
    rev = "672bdc28c29c30e8ac7ce571a551fdc0b3a66193";
    hash = "sha256-1fD/Q+UtEslK0cQq6m1zj5kwn/yrUf9tYqV7z5/smgo=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vs.get_pkgconfig_variable('libdir')" \
      "get_option('libdir')"
  '';

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    vapoursynth
  ];

  meta = with lib; {
    description = "VapourSynth plugin to undo upscaling";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-descale";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
