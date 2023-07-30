{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, libdovi
, libplacebo
, vapoursynth
, vulkan-headers
, vulkan-loader
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-placebo";
  version = "unstable-2023-05-26";

  src = fetchFromGitHub {
    owner = "Lypheo";
    repo = "vs-placebo";
    rev = "701d72126b58ccfb64f81ed19cacac93bd7fb2a0";
    hash = "sha256-tF4TDb2NHT6eqaBfDEPoHbGGD+6SeMGigARCQJF+Yeg=";
    fetchSubmodules = true;
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
    libdovi
    libplacebo
    vapoursynth
    vulkan-headers
    vulkan-loader
  ];

  meta = with lib; {
    description = "libplacebo-based debanding, scaling and color mapping plugin for VapourSynth";
    homepage = "https://github.com/Lypheo/vs-placebo";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
