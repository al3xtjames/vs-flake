{ lib
, stdenv
, fetchFromGitHub
, rustPlatform
, a52dec
, libdvdread
, libmpeg2
, vapoursynth
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
rustPlatform.buildRustPackage rec {
  pname = "vapoursynth-dvdsrc2";
  version = "unstable-2023-11-15";

  src = fetchFromGitHub {
    owner = "jsaowji";
    repo = "dvdsrc2";
    rev = "27fc5a8ca60c535577f55592ca429951655d21b3";
    hash = "sha256-wREryQBOZSGKBNBO0zxw3/ckIRNKXQiokSS3uEUkPjA=";
  };

  buildInputs = [
    a52dec
    libdvdread
    libmpeg2
    vapoursynth
  ];

  cargoLock = {
    lockFile = builtins.toPath "${src}/Cargo.lock";
    outputHashes = {
      "bincode-2.0.0-rc.3" = "sha256-UeiwUx2hKILix8yQOICXSIUj+VoIAskpYIx0S9vmhQA=";
      "vapoursynth4-rs-0.2.0" = "sha256-9MBqUYZejfu0GoYQ+FnAKaaNOxiH+lY0L7CuD+eV16I=";
    };
  };

  postInstall = ''
    mkdir -p $out/lib/vapoursynth
    ln -s $out/lib/libdvdsrc2${ext} $out/lib/vapoursynth/
  '';

  meta = with lib; {
    description = "VapourSynth DVD source plugin";
    homepage = "https://github.com/jsaowji/dvdsrc2";
    license = licenses.unfree; # no license?
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
