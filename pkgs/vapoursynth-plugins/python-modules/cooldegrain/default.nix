{ lib
, buildPythonPackage
, python
, fetchurl
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    fmtconv
    mvtools
  ];
in
buildPythonPackage rec {
  pname = "cooldegrain";
  version = "unstable-2022-08-03";
  format = "other";

  src = fetchurl {
    url = "https://cdn.discordapp.com/attachments/428899983417147402/1004518736574812181/cooldegrain.py";
    hash = "sha256-ZnwiRUwJrKb2RQdPsQT+qzGD4XPAEGgUZEw0fWzi5A4=";
  };

  dontUnpack = true;

  propagatedBuildInputs = vsPluginInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D $src $out/${python.sitePackages}/cooldegrain.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "cooldegrain"
  ];

  meta = with lib; {
    description = "Port of CoolDegrain1/2/3 as stand-alone script";
    homepage = "https://discord.com/invite/R4Hsntp";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
