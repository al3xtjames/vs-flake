{ lib
, stdenv
, fetchFromGitHub
, libass
, libpng
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "ass2bdnxml";
  version = "0.4";

  src = fetchFromGitHub {
    owner = "cubicibo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CdXhG8YtYKtTRJmkIny+2lqy0X2Co0rzMwIlxRUNoNQ=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libass
    libpng
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/bin"
    mv ass2bdnxml "$out/bin"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Convert ASS subtitles into BDN XML + PNG images";
    license = licenses.isc;
    platforms = platforms.all;
    maintainers = [ ];
  };
}
