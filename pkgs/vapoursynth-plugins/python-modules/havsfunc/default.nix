{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, hatchling
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    awarpsharp2
    bwdif
    cas
    dctfilter
    deblock
    dfttest
    eedi3
    fft3dfilter
    fluxsmooth
    hqdn3d
    miscfilters-obsolete
    mvtools
    neo-f3kdb
    nnedi3cl
    removegrain
    ttempsmooth
    znedi3
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    adjust
    mvsfunc
    nnedi3-resample
    vsdenoise
    vsexprtools
    vsmasktools
    vsrgtools
    vstools
  ];
in
buildPythonPackage rec {
  pname = "havsfunc";
  version = "unstable-2023-05-07";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "0f6a7d9d9712d59b4e74e1e570fc6e3a526917f9";
    hash = "sha256-PFiaRHtrh0ZC4ZJrk0yUekpKFXlm+zRanncMgwokQvI=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    hatchling
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "havsfunc"
  ];

  meta = with lib; {
    description = "Holy's ported AviSynth functions for VapourSynth";
    homepage = "https://github.com/HomeOfVapourSynthEvolution/havsfunc";
    license = licenses.unlicense;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
