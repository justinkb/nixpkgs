{ lib, stdenv, fetchurl, readline }:

stdenv.mkDerivation rec {
  pname = "mujs";
  version = "1.1.3";

  src = fetchurl {
    url = "https://mujs.com/downloads/mujs-${version}.tar.xz";
    sha256 = "sha256-TSTpUJqea9I9fKFh0Kggvml+fmFD2aVx+tdUGyIcIKY=";
  };

  buildInputs = [ readline ];

  makeFlags = [ "prefix=$(out)" ];

  meta = with lib; {
    homepage = "https://mujs.com/";
    description = "A lightweight, embeddable Javascript interpreter";
    platforms = platforms.unix;
    maintainers = with maintainers; [ pSub ];
    license = licenses.isc;
  };
}
