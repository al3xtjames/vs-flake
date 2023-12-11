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
  version = "unstable-2023-11-02";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = pname;
    rev = "f11d79c98589c9dcb5b10beec35b631db68b495c";
    hash = "sha256-EOlo405e8ZgqEM1ZXCptSYhEPQHJO+fyWxK395CR9pw=";
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
