{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages
, vapoursynth
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-fgrain-cuda";
  version = "1";

  src = fetchFromGitHub {
    owner = "AmusementClub";
    repo = "vs-fgrain-cuda";
    rev = "v${version}";
    hash = "sha256-KToyE9YHSaGEl+7B2OvhcbDtfwnWN+VFr/09y6sN2yU=";
  };

  nativeBuildInputs = [
    cmake
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    cudaPackages.cudatoolkit
    vapoursynth
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_CUDA_ARCHITECTURES=52;61-real;75-real;86-real"
    "-DCMAKE_CUDA_FLAGS=--use_fast_math"
    "-DCMAKE_INSTALL_LIBDIR=lib/vapoursynth"
    "-DVS_INCLUDE_DIR=${vapoursynth}/include/vapoursynth"
  ];

  # https://github.com/NixOS/nixpkgs/issues/114044
  preConfigure = ''
    cmakeFlagsArray+=(
      "-DCMAKE_CUDA_FLAGS=--threads 0 --use_fast_math"
    )
  '';

  meta = with lib; {
    description = "Realistic Film Grain Rendering for VapourSynth, implemented in CUDA";
    homepage = "https://github.com/AmusementClub/vs-fgrain-cuda";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
