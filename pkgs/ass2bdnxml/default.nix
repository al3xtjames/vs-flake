{ lib
, stdenv
, fetchFromGitHub
, libass
, libimagequant
, libpng
, meson
, ninja
, pkg-config
}:

stdenv.mkDerivation rec {
  pname = "ass2bdnxml";
  version = "0.6a";

  src = fetchFromGitHub {
    owner = "cubicibo";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-ZhuVvnRIJF83Q+EYoMVK1TYu3B62TpZGObza2tJXsNg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    libass
    libimagequant
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
