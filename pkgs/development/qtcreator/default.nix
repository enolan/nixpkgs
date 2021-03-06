{ stdenv, fetchurl, makeWrapper, qtLib, withDocumentation ? false }:

with stdenv.lib;

let
  baseVersion = "3.5";
  revision = "1";
  version = "${baseVersion}.${revision}";
in

stdenv.mkDerivation rec {
  name = "qtcreator-${version}";

  src = fetchurl {
    url = "http://download.qt-project.org/official_releases/qtcreator/${baseVersion}/${version}/qt-creator-opensource-src-${version}.tar.gz";
    sha256 = "0r9ysq9hzig4ag9m8pcpw1jng2fqqns8zwp0jj893gh8ia0sq9ar";
  };

  buildInputs = [ makeWrapper qtLib.base qtLib.script qtLib.quickcontrols qtLib.declarative ];

  doCheck = false;

  enableParallelBuilding = true;

  preConfigure = ''
    qmake -spec linux-g++ qtcreator.pro
  '';

  buildFlags = optionalString withDocumentation " docs";

  installFlags = "INSTALL_ROOT=$(out)"
    + optionalString withDocumentation " install_docs";

  postInstall = ''
    # Install desktop file
    mkdir -p "$out/share/applications"
    cat > "$out/share/applications/qtcreator.desktop" << __EOF__
    [Desktop Entry]
    Exec=$out/bin/qtcreator
    Name=Qt Creator
    GenericName=Cross-platform IDE for Qt
    Icon=QtProject-qtcreator.png
    Terminal=false
    Type=Application
    Categories=Qt;Development;IDE;
    __EOF__
    # Wrap the qtcreator binary
    addToSearchPath QML2_IMPORT_PATH "${qtLib.quickcontrols}/lib/qt5/qml"
    addToSearchPath QML2_IMPORT_PATH "${qtLib.declarative}/lib/qt5/qml"
    wrapProgram $out/bin/qtcreator \
      --prefix QT_PLUGIN_PATH : "$QT_PLUGIN_PATH" \
      --prefix QML_IMPORT_PATH : "$QML_IMPORT_PATH" \
      --prefix QML2_IMPORT_PATH : "$QML2_IMPORT_PATH"
  '';

  meta = {
    description = "Cross-platform IDE tailored to the needs of Qt developers";
    longDescription = ''
      Qt Creator is a cross-platform IDE (integrated development environment)
      tailored to the needs of Qt developers. It includes features such as an
      advanced code editor, a visual debugger and a GUI designer.
    '';
    homepage = "https://wiki.qt.io/Category:Tools::QtCreator";
    license = "LGPL";
    maintainers = [ maintainers.akaWolf maintainers.bbenoist ];
    platforms = platforms.all;
  };
}
