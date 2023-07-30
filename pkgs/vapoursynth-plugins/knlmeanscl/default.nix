{ lib
, stdenv
, fetchFromGitHub
, meson
, ninja
, pkg-config
, boost
, ocl-icd
, opencl-headers
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "KNLMeansCL";
  version = "unstable-2023-01-05";

  src = fetchFromGitHub {
    owner = "Khanattila";
    repo = pname;
    rev = "ca424fa91d1e16ec011f7db9c3ba0d1e76ed7850";
    hash = "sha256-co8Jaup3bvvJaKw830CqCkAKHRsT5rx/xAYMbGhrMRk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    boost
    ocl-icd
    opencl-headers
    vapoursynth
  ];

  # https://github.com/NixOS/nixpkgs/issues/86131
  preConfigure = ''
    export BOOST_INCLUDEDIR="${lib.getDev boost}/include";
    export BOOST_LIBRARYDIR="${lib.getLib boost}/lib";
  '';

  meta = with lib; {
    description = "An optimized OpenCL implementation of the Non-local means de-noising algorithm";
    homepage = "https://github.com/Khanattila/KNLMeansCL";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
