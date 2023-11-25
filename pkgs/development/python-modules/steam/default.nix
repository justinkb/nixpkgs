{ lib
, buildPythonPackage
, fetchPypi
, six
, pycryptodomex
, requests
, urllib3
, vdf
, cachetools
, enum34
, gevent
, protobuf3
, gevent-eventemitter
}:

buildPythonPackage rec {
  pname = "steam";
  version = "1.4.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-K1vWkRwNSnMS9EG40WK52NR8i+u478bIhnOTsDI/pS4=";
  };

  propagatedBuildInputs = [
    six
    pycryptodomex
    requests
    urllib3
    vdf
    cachetools
    enum34
  ];

  passthru.optional-dependencies = {
    client = [
      gevent
      protobuf3
      gevent-eventemitter
    ];
  };

  pythonImportCheck = [ "steam" ];

  checkInputs = [
    protobuf3
    gevent-eventemitter
  ];

  meta = with lib; {
    description = "Python package for interacting with Steam";
    homepage = "https://github.com/ValvePython/steam";
    license = licenses.mit;
  };
}
