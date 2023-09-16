{ lib
, stdenv
, fetchFromGitHub
, cmake
, cudaPackages ? { }
, vapoursynth
, config
, cudaSupport ? config.cudaSupport
}:

stdenv.mkDerivation rec {
  pname = "vapoursynth-bm3dcuda";
  version = "2.13.test";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = pname;
    rev = "R${version}";
    hash = "sha256-/ng+QAW2ZlrnfCjG9dKsG68fsfm0ZL3bGVCktnXlDlw=";
  };

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals cudaSupport [
    cudaPackages.autoAddOpenGLRunpathHook
  ];

  buildInputs = [
    vapoursynth
  ] ++ lib.optionals cudaSupport [
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_INSTALL_LIBDIR=lib/vapoursynth"
    "-DENABLE_CUDA=${lib.boolToString cudaSupport}"
    "-DVAPOURSYNTH_INCLUDE_DIRECTORY=${vapoursynth}/include/vapoursynth"
  ] ++ lib.optionals cudaSupport [
    "-DCMAKE_CUDA_ARCHITECTURES=50;61-real;75-real;86"
  ];

  # https://github.com/NixOS/nixpkgs/issues/114044
  preConfigure = lib.optionalString cudaSupport ''
    cmakeFlagsArray+=(
      "-DCMAKE_CUDA_FLAGS=--threads 0 --use_fast_math -Wno-deprecated-gpu-targets"
    )
  '';

  meta = with lib; {
    description = "BM3D denoising filter for VapourSynth, implemented in CUDA";
    homepage = "https://github.com/WolframRhodium/VapourSynth-BM3DCUDA";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
