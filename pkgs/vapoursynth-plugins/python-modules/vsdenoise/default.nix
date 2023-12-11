{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, scipy
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    bm3dcuda
    bmdegrain
    fft3dfilter
    mvtools
    mvtools-sf
    nlm-cuda
    wnnm
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    dfttest2
    vsaa
    vsexprtools
    vskernels
    vsmasktools
    vsrgtools
    vsscale
    vsmlrt
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-denoise";
  version = "2.5.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-/MoW7IcVxzs4iMMRB3ElqJ5Xe9uEm4q9jmYIveGXaEs=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs ++ [
    scipy
  ];

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsdenoise"
  ];

  meta = with lib; {
    description = "VapourSynth denoising, regression, and motion compensation functions";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-denoise";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
