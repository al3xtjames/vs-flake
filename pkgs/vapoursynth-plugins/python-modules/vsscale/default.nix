{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
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
  version = "1.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-NTK61Cttcr1RdtYFcW01dkRKhvsDfAy9eCJD0LdyKds=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vsscale"
  ];

  meta = with lib; {
    description = "VapourSynth (de)scaling functions";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-scale";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
