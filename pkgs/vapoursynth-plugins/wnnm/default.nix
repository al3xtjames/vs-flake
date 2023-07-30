{ lib
, stdenv
, fetchFromGitHub
, cmake
, mkl
, vapoursynth
}:

let
  vectorclass = fetchFromGitHub {
    owner = "vectorclass";
    repo = "version2";
    rev = "v2.02.01";
    hash = "sha256-45qt0vGz6ibEmcoPZDOeroSivoVnFkvMEihjXJXa8lU=";
  };
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-wnnm";
  version = "unstable-2023-07-06";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = pname;
    rev = "a8977b4365841bb27c232383cd9a306f70ef9f99";
    hash = "sha256-B4jvl+Lu724QofDbKQObdcpQdlb8KQ2szAp780J9SUY=";
  };

  patches = [
    ./fix-compilation.patch
  ];

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    mkl
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_LIBDIR=lib/vapoursynth"
    "-DVCL_HOME=${vectorclass}"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
  ];

  meta = with lib; {
    description = "Weighted Nuclear Norm Minimization Denoiser for VapourSynth";
    homepage = "https://github.com/WolframRhodium/VapourSynth-WNNM";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
