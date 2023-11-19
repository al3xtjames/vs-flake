{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-dpid";
  version = "6-APIv4";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "r${version}";
    hash = "sha256-N19tkX//meN6x8S3s5lhCKfazUFmEpOjxGsky/KS6p4=";
  };

  postPatch = ''
    substituteInPlace Source/meson.build --replace \
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

  preConfigure = ''
    cd Source
  '';

  meta = with lib; {
    description = "Rapid, Detail-Preserving Image Downscaler for VapourSynth";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/VapourSynth-dpid";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
