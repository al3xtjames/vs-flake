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
  version = "9";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = "vapoursynth-descale";
    rev = "r${version}";
    hash = "sha256-8OI9fCOq0XnX0rT291zV5gHxf97zNa5INfhS06xSX1I=";
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
