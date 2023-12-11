{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, cupy
, numpy
, config
, cudaSupport ? config.cudaSupport
, nix-update-script
}:

let
  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    vstools
  ];
in
buildPythonPackage rec {
  pname = "vs-pyplugin";
  version = "1.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Jaded-Encoding-Thaumaturgy";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-XQAPVcYr2dU0fdfPsEfGQbRVHhEHJtq3/W/dseFmIm0=";
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

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Package for simplifying writing VapourSynth plugins in python";
    homepage = "https://github.com/Jaded-Encoding-Thaumaturgy/vs-pyplugin";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
