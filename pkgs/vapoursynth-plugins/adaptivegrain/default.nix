{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, vapoursynth
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
rustPlatform.buildRustPackage rec {
  pname = "vapoursynth-adaptivegrain";
  version = "unstable-2021-05-29";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = "adaptivegrain";
    rev = "1c062e6dd08dddd10b2933e4f4b8fbba27477969";
    hash = "sha256-mThtNqAnImgMBAT808mwgQ5IlzrtTkaF6gEVdyzTEps=";
  };

  buildInputs = [
    vapoursynth
  ];

  cargoHash = "sha256-9Yb6FhAWGMD5ECe0poKrrJ/suGCLia+L4zfoIMTvRLY=";

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libadaptivegrain_rs${ext} $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "Reimplementation of the adaptive_grain mask as a Vapoursynth plugin";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/adaptivegrain";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
