{ lib
, buildPythonPackage
, fetchFromGitHub
, util-linux
, vapoursynth
, vapoursynthPlugins
, nix-update-script
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    dvdsrc2
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-source";
  version = "0.10.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AZ5NKf74c1fuhzrST4B52hv7g4yMJafa8xmSI1ue/GE=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  buildInputs = [
    util-linux
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vssource"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "VapourSynth (de)scaling functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-source";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
