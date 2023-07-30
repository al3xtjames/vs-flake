{ lib
, buildPythonPackage
, python
, fetchurl
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    eedi3
    fmtconv
    sangnom
    tmaskcleaner
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    mvsfunc
  ];
in
buildPythonPackage rec {
  pname = "hardaap2";
  version = "unstable-2022-03-05";
  format = "other";

  src = fetchurl {
    url = "https://cdn.discordapp.com/attachments/428899983417147402/949782960645746708/HardAAp2.py";
    hash = "sha256-S74k0uKUgy91gKztGmON9BwfedJ1OF2mY9RD/+c7g2I=";
  };

  dontUnpack = true;

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/${python.sitePackages}/HardAAp2.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "HardAAp2"
  ];

  meta = with lib; {
    description = "HardAA for really hard anti-aliasing purposes";
    homepage = "https://discord.com/invite/R4Hsntp";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
