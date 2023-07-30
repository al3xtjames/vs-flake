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
  pname = "vapoursynth-nlq";
  version = "unstable-2023-07-26";

  src = fetchFromGitHub {
    owner = "quietvoid";
    repo = "vs-nlq";
    rev = "123151d7ea3c20dfe94cd12a8aadeee896f045eb";
    hash = "sha256-gtqT8ORSZaL71wbibwD7l1kuBIgSM8pDN8PNpFwjqM8=";
  };

  buildInputs = [
    vapoursynth
  ];

  cargoPatches = [
    ./add-Cargo.lock.patch
  ];

  cargoHash = "sha256-r30gzOjbs+isJ1kCL4hCX9bzLsjjgGf8RjJOfif++2g=";

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libvs_nlq${ext} $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "Dolby Vision reconstruction for VapourSynth";
    homepage = "https://github.com/quietvoid/vs-nlq";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
