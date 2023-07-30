{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, tbb
, vapoursynth
}:

let
  ext = stdenv.hostPlatform.extensions.sharedLibrary;
in
stdenv.mkDerivation rec {
  pname = "vapoursynth-neo-f3kdb";
  version = "9";

  src = fetchFromGitHub {
    owner = "HomeOfAviSynthPlusEvolution";
    repo = "neo_f3kdb";
    rev = "r${version}";
    hash = "sha256-MIvKjsemDeyv9qonuJbns0Dau8BjFQ1REppccs7s9JU=";
  };

  patches = [
    ./remove-git-usage.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    tbb
    vapoursynth
  ];

  cmakeFlags = [
    "-DGIT_REPO_VERSION=${src.rev}"
  ];

  installPhase = ''
    runHook preInstall

    install -D libneo-f3kdb${ext} $out/lib/vapoursynth/libneo-f3kdb${ext}

    runHook postInstall
  '';

  meta = with lib; {
    description = "Deband filter (forked from SAPikachu/flash3kyuu_deband)";
    homepage = "https://github.com/HomeOfAviSynthPlusEvolution/neo_f3kdb";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
