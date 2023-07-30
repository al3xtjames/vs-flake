{ lib
, stdenvNoCC
, buildPythonPackage
, python
, fetchPypi
, jupyter
, jupyterlab
, ipywidgets
, pillow
, vapoursynth
, pytest
}:

let
  pname = "yuuno";
  version = "1.4";
  meta = with lib; {
    description = "Yuuno = Jupyter + VapourSynth";
    homepage = "https://yuuno.encode.moe";
    license = licenses.agpl3Plus;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };

  self = plugins: buildPythonPackage rec {
    inherit pname version meta;
    format = "setuptools";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-z7OFHijfwcZb/p950qrGk3ihDM8FJznsaDLKWbck5Gc=";
    };

    patches = [
      ./fix-package.json-path.patch
    ];

    postPatch = ''
      # Broken with VapourSynth APIv4
      rm tests/_test_vapoursynth_support.py
    '';

    propagatedBuildInputs = [
      jupyter
      jupyterlab
      ipywidgets
      pillow
      (vapoursynth.withPlugins plugins)
    ];

    checkInputs = [
      pytest
    ];
  };
in
stdenvNoCC.mkDerivation {
  inherit pname version meta;

  dontUnpack = true;

  passthru.withPlugins = plugins: python.buildEnv.override {
    extraLibs = [ (self plugins) ] ++ plugins;
  };
}
