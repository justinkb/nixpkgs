{ lib
, buildPythonPackage
, fetchPypi
, steam
, appdirs
, argcomplete
, tqdm
, arrow
, pyqrcode
, vpk
, beautifulsoup4
}:

buildPythonPackage rec {
  pname = "steamctl";
  version = "0.9.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1ryM9g5NZyD7946+ziwoG/9dAlNxAkXmWilUZMQ1r0I=";
  };

  propagatedBuildInputs = [
    steam
    steam.optional-dependencies.client
    appdirs
    argcomplete
    tqdm
    arrow
    pyqrcode
    vpk
    beautifulsoup4
  ];

  pythonImportCheck = [ "steamctl" ];

  meta = with lib; {
    description = "Take control of Steam from your terminal";
    homepage = "https://github.com/ValvePython/steamctl";
    license = licenses.mit;
  };
}
