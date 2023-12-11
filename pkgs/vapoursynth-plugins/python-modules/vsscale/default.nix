{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, nix-update-script
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    dpid
    placebo
    trt
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vsaa
    vsexprtools
    vskernels
    vsmasktools
    vsmlrt
    vsrgtools
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-scale";
  version = "2.0.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-CWOpDsbFP3zHHLnYwKS366AO9WqDplwlUnVkZDefXLw=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsscale"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "VapourSynth (de)scaling functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-scale";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
