{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, cupy
, numpy
, cudaSupport ? true
}:

let
  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-pyplugin";
  version = "1.3.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-uFo8dk4fPyGq3YFCfw/BoPMe1IFJDW8liVrn641C4h0=";
  };

  patches = [
    ./catch-libcuda-ImportError.patch
  ];

  propagatedBuildInputs = vsPythonInputs ++ [
    numpy
  ] ++ lib.optionals cudaSupport [
    cupy
  ];

  nativeBuildInputs = [
    vapoursynth
  ];

  doCheck = false;

  pythonImportsCheck = [
    "vspyplugin"
  ];

  meta = with lib; {
    description = "Package for simplifying writing VapourSynth plugins in python";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vs-pyplugin";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
