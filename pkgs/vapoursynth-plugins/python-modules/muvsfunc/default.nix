{ lib
, buildPythonPackage
, python
, fetchFromGitHub
, vapoursynth
, vapoursynthPlugins
, matplotlib
}:

let
  vsPluginInputs = with vapoursynthPlugins; [
    akarin
    awarpsharp2
    bilateral
    cas
    ctmf
    descale
    dfttest
    eedi2
    # filter - Windows only
    # filtermod - Windows only
    fmtconv
    miscfilters-obsolete
    mvtools
    # mxnet - Windows only
    removegrain
    sangnom
    tcanny
    temporalmedian
    znedi3
  ];

  vsPythonInputs = with vapoursynthPlugins.pythonModules; [
    mvsfunc
    nnedi3-resample
  ];
in
buildPythonPackage rec {
  pname = "muvsfunc";
  version = "unstable-2023-07-06";
  format = "other";

  src = fetchFromGitHub {
    owner = "WolframRhodium";
    repo = pname;
    rev = "e90bd4e7157aaf32c6ec61ddc60191e75259c3d7";
    hash = "sha256-RtWhTmLr8mTvKE5fRh8n1cp9H5so4JKQMrGjGK2MOXw=";
  };

  propagatedBuildInputs = vsPluginInputs ++ vsPythonInputs ++ [
    matplotlib
  ];

  nativeBuildInputs = [
    (vapoursynth.withPlugins vsPluginInputs)
  ];

  installPhase = ''
    runHook preInstall

    install -D muvsfunc.py $out/${python.sitePackages}/muvsfunc.py

    runHook postInstall
  '';

  pythonImportsCheck = [
    "muvsfunc"
  ];

  meta = with lib; {
    description = "Muonium's VapourSynth functions";
    homepage = "https://github.com/WolframRhodium/muvsfunc";
    license = licenses.unfree; # no license
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
