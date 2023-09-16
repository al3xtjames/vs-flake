{ lib
, buildPythonPackage
, fetchFromGitHub
, vapoursynth
, unittestCheckHook
}:

buildPythonPackage rec {
  pname = "vsutil";
  version = "unstable-2022-11-18";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Irrational-Encoding-Wizardry";
    repo = pname;
    rev = "fc0629e8b3fe691d7493e2a9fbc070890e7e9918";
    hash = "sha256-PrX6BXW6PSzMS3viMEPUTiTUEKmhu44zE/huRzPwIlA=";
  };

  nativeBuildInputs = [
    vapoursynth
  ];

  nativeCheckInputs = [
    unittestCheckHook
  ];

  unittestFlags = [
    "-s"
    "tests"
  ];

  pythonImportsCheck = [
    "vsutil"
  ];

  meta = with lib; {
    description = "A collection of general purpose Vapoursynth functions to be reused in modules and scripts";
    homepage = "https://github.com/Irrational-Encoding-Wizardry/vsutil";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
