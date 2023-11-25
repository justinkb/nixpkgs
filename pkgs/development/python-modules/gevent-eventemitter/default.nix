{ lib
, buildPythonPackage
, fetchPypi
, gevent
}:

buildPythonPackage rec {
  pname = "gevent-eventemitter";
  version = "2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-AObmiMaiVfe9zvHYyZng0C2auH08b/Ym5twaCXYhB/Q=";
  };

  propagatedBuildInputs = [
    gevent
  ];

  pythonImportCheck = [ "eventemitter" ];

  doCheck = false;

  meta = with lib; {
    description = "Implements EventEmitter using gevent";
    homepage = "https://github.com/rossengeorgiev/gevent-eventemitter";
    license = licenses.mit;
  };
}
