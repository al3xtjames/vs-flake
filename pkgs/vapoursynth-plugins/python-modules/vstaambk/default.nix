{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, nix-update-script
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    eedi2
    eedi2cuda
    eedi3
    fmtconv
    mvtools
    sangnom
    tcanny
    nnedi3cl
    znedi3
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    havsfunc
    mvsfunc
  ];
in
buildPythonPackage rec {
  pname = "vstaambk";
  version = "0.8.2";
  format = "other";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-fOMx4rEfqXAVds1rnHyP+srS8zSY9rMgRVdo4zZ0GhU=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D vsTAAmbk.py $out/${python.sitePackages}/vsTAAmbk.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "vsTAAmbk"
  ];

  meta = with lib; {
    description = "A ported AA-script from Avisynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/vsTAAmbk";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
