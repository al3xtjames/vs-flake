{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-trt";
  version = "13.2";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-mlrt";
    rev = "v${version}";
    hash = "sha256-JblJvafWBTVCBp0BwcqTMazjjHNmE6grIi6Sc3ZfW3o=";
  };

  patches = [
    ./remove-git-usage.patch
  ];

  nativeBuildInputs = [
    cmake
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    cudaPackages.cudatoolkit
    cudaPackages.tensorrt
    vapoursynth
  ];

  preConfigure = ''
    cd vstrt
  '';

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_LIBDIR=lib/vapoursynth"
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
    "-DVAPOURSYNTH_INCLUDE_DIRECTORY=${vapoursynth}/include/vapoursynth"
    "-DVCS_TAG=${src.rev}"
  ];

  meta = with lib; {
    description = "Optimized CUDA runtime for some popular AI filters";
    homepage = "https://github.com/AmusementClub/vs-mlrt";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
