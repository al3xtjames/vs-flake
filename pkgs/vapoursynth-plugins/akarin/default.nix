{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, llvm
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-akarin";
  version = "unstable-2023-03-26";

  src = fetchFromGitHub {
    owner = "AkarinVS";
    repo = "vapoursynth-plugin";
    rev = "8b7ff6dcc85bc9935789c799e63f1388dfbd1bd4";
    hash = "sha256-azo5iD1gvGaMkIdRV7ZX2KQxEJ61B1j7mrhVdtrfarE=";
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
    llvm
    vapoursynth
  ];

  mesonFlags = [
    "-Dstatic-llvm=false"
  ];

  meta = with lib; {
    description = "Experimental VapourSynth plugin by AkarinVS";
    longDescription = ''
      An experimental VapourSynth plugin:
      (1) an enhanced LLVM-based std.Expr (aka lexpr), Select, PropExpr, Text and Tmpl.
      (2) DLISR.
      (3) DLVFX.
      (4) CAMBI.
    '';
    homepage = "https://github.com/AkarinVS/vapoursynth-plugin";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
