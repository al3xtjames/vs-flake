{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bilateral";
  version = "unstable-2023-06-27";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "1a2a4f6a70a6e0ef2fc62009c9f5ae1b5ed56ebe";
    hash = "sha256-wGuoar8TNkO/HJo5LA33IehXVRd/749oQ17AKZ76PAo=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vapoursynth_dep.get_variable(pkgconfig: 'libdir')" \
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
    description = "Bilateral filter for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vapoursynth-Bilateral";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
