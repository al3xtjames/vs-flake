{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, vapoursynth
}:

buildPythonPackage rec {
  pname = "vapoursynth-adjust";
  version = "unstable-2021-10-06";
  format = "other";

  src = fetchFromGitHub {
    owner = "dubhater";
    repo = pname;
    rev = "a3af7cb57cb37747b0667346375536e65b1fed17";
    hash = "sha256-2uziVezy8uOx1oFnK2JyDP9DYzXG892Q/1XObd3q6Mc=";
  };

  nativeBuildInputs = [
    vapoursynth
  ];

  installPhase = ''
    runHook preInstall

    install -D adjust.py $out/${python.sitePackages}/adjust.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "adjust"
  ];

  meta = with lib; {
    description = "Basic port of the built-in Avisynth filter Tweak";
    homepage = "https://github.com/dubhater/vapoursynth-adjust";
    license = licenses.wtfpl;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
