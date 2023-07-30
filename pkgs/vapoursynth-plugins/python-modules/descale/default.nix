{ lib
, buildPythonPackage
, python
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    descale
  ];
in
buildPythonPackage {
  inherit (vapoursynthPlugins.descale) pname version src meta;
  format = "other";

  propagatedBuildInputs = vsPluginInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D descale.py $out/${python.sitePackages}/descale.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "descale"
  ];
}
