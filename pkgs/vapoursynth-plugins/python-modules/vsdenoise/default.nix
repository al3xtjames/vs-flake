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
  version = "2.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-V0pNybw1FQGSVQBehZbQ08WWPLU6Ds0jxR0NvCZVYXg=";
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
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-denoise";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
