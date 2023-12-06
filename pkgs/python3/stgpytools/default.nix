{ lib
, buildPythonPackage
, fetchFromGitHub
}:

buildPythonPackage rec {
  pname = "stgpytools";
  version = "1.0.4";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Setsugennoao";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-kFJxeA2hYeA0lNJ040gZqFgtCoAwEnNgB0f9vDUBqg4=";
  };

  pythonImportsCheck = [
    "stgpytools"
  ];

  meta = with lib; {
    description = "Collection of stuff that's useful in general python programming";
    homepage = "https://github.com/Setsugennoao/stgpytools";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    platforms = platforms.all;
  };
}
