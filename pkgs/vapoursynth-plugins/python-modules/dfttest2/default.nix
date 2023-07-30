{ lib
, buildPythonPackage
, python
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    dfttest2
  ];
in
buildPythonPackage {
  inherit (vapoursynthPlugins.dfttest2) pname version src meta;
  format = "other";

  propagatedBuildInputs = vsPluginInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D dfttest2.py $out/${python.sitePackages}/dfttest2.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "dfttest2"
  ];
}
