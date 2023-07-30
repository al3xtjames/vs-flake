{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    fmtconv
    nnedi3cl
    znedi3
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    mvsfunc
  ];
in
buildPythonPackage rec {
  pname = "nnedi3-resample";
  version = "unstable-2022-08-14";
  format = "other";

  src = fetchFromGitHub {
    owner = "HomeOfVapourSynthEvolution";
    repo = "nnedi3_resample";
    rev = "eb53450a19f41f8435f36099f083ede0ae836c83";
    hash = "sha256-eoGbzhMu2D2g7Z/Es5Nx4x6K0Lg1a7jbSvR2q8WpowE=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs;

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D nnedi3_resample.py $out/${python.sitePackages}/nnedi3_resample.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "nnedi3_resample"
  ];

  meta = with lib; {
    description = "Resizing using nnedi3/znedi3/nnedi3cl with center alignment and correct chroma placement";
    longDescription = ''
      A VapourSynth script for easy resizing using nnedi3/znedi3/nnedi3cl with center alignment and correct chroma placement.
      It can do scaling, color space conversion, etc.
    '';
    homepage = "https://github.com/HomeOfVapourSynthEvolution/nnedi3_resample";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
