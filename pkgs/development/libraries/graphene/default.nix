{ lib, stdenv
, fetchFromGitHub
, nix-update-script
, pkg-config
, meson
, ninja
, python3
, mutest
, nixosTests
, glib
, gtk-doc
, docbook_xsl
, docbook_xml_dtd_43
, gobject-introspection
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "graphene";
  version = "1.10.6";

  outputs = [ "out" ]
    ++ lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform) [ "devdoc" "installedTests" ];

  src = fetchFromGitHub {
    owner = "ebassi";
    repo = pname;
    rev = version;
    sha256 = "v6YH3fRMTzhp7wmU8in9ukcavzHmOAW54EK9ZwQyFxc=";
  };

  patches = [
    # Add option for changing installation path of installed tests.
    ./0001-meson-add-options-for-tests-installation-dirs.patch
  ];

  depsBuildBuild = [
    pkg-config
  ];

  nativeBuildInputs = [
    docbook_xml_dtd_43
    docbook_xsl
    gtk-doc
    meson
    ninja
    pkg-config
    gobject-introspection
    python3
    makeWrapper
  ];

  buildInputs = [
    glib
  ];

  checkInputs = [
    mutest
  ];

  mesonFlags = [
    "-Dgtk_doc=${lib.boolToString (stdenv.buildPlatform == stdenv.hostPlatform)}"
    "-Dintrospection=${if (stdenv.buildPlatform == stdenv.hostPlatform) then "enabled" else "disabled"}"
    "-Dinstalled_test_datadir=${placeholder "installedTests"}/share"
    "-Dinstalled_test_bindir=${placeholder "installedTests"}/libexec"
  ];

  doCheck = true;

  postPatch = ''
    patchShebangs tests/gen-installed-test.py
  '' + lib.optionalString (stdenv.buildPlatform == stdenv.hostPlatform) ''
    PATH=${python3.withPackages (pp: [ pp.pygobject3 pp.tappy ])}/bin:$PATH patchShebangs tests/introspection.py
  '';

  postFixup = let
    introspectionPy = "${placeholder "installedTests"}/libexec/installed-tests/graphene-1.0/introspection.py";
  in ''
    if [ -x '${introspectionPy}' ] ; then
      wrapProgram '${introspectionPy}' \
        --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0"
    fi
  '';

  passthru = {
    tests = {
      installedTests = nixosTests.installed-tests.graphene;
    };

    updateScript = nix-update-script {
      attrPath = pname;
    };
  };

  meta = with lib; {
    description = "A thin layer of graphic data types";
    homepage = "https://ebassi.github.com/graphene";
    license = licenses.mit;
    maintainers = teams.gnome.members ++ (with maintainers; [ ]);
    platforms = platforms.unix;
  };
}
