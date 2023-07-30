{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    descale
    fmtconv
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-kernels";
  version = "2.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-oIVEw31MXQzNVvcKCNdgEzvN1Q9t+0r5y01yJHF7v/Y=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  pythonImportsCheck = [
    "vskernels"
  ];

  meta = with lib; {
    description = "Kernel objects for scaling and format conversion within VapourSynth";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-kernels";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
