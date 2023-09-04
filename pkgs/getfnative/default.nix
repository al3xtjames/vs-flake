{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, matplotlib
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    descale
    imwri
  ];
in
buildPythonPackage rec {
  pname = "getfnative";
  version = "unstable-2023-03-30";
  format = "other";

  src = fetchFromGitHub {
    owner = "YomikoR";
    repo = pname;
    rev = "18c396f55c8041bfb8eb90096d948d7e411fc336";
    hash = "sha256-e0sq4oHxorQhY7v8oGA9MVXCdwVCiHSzAM8u2YCHF8U=";
  };

  propagatedBuildInputs = [
    matplotlib
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D getfnative.py $out/${python.sitePackages}/getfnative.py
    install -D getfnativeq.py $out/${python.sitePackages}/getfnativeq.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "getfnative"
    "getfnativeq"
  ];

  meta = with lib; {
    description = "A script that help find the native fractional resolution of upscaled material (mostly anime)";
    homepage = "https://github.com/YomikoR/GetFnative";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
