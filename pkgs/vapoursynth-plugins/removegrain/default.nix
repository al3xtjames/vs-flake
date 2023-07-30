{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-removegrain";
  version = "unstable-2022-10-28";

  src = fetchFromGitHub {
    owner = "vapoursynth";
    repo = "vs-removegrain";
    rev = "89ca38a6971e371bdce2778291393258daa5f03b";
    hash = "sha256-UcS8EjZGCX00Pt5pAxBTzCiveTKS5yeFT+bQgXKnJ+k=";
  };

  postPatch = ''
    substituteInPlace meson.build --replace \
      "vapoursynth_dep.get_pkgconfig_variable('libdir')" \
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
    description = "VapourSynth port of RemoveGrain and Repair plugins from Avisynth";
    homepage = "https://github.com/vapoursynth/vs-removegrain";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
