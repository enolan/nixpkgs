{ stdenv, fetchFromGitHub
, autoconf, automake, gettext, libtool, pkgconfig
, gtk2, libv4l, libXext, libXtst, opencv3, wxgtk }:

stdenv.mkDerivation rec {
  name = "eviacam-${version}";
  version = "2.1.3";

  src = fetchFromGitHub {
    owner = "cmauri";
    repo = "eviacam";
    rev = "22caf8ea8a33643c05381723beed44522b1fc3b1";
    sha256 = "08w6myxs638lc2w5xan3ybgbx6p919yv9xfscdz49l092s87m0fh";
  };

  preConfigure = "./autogen.sh";

  patches = [ ./fixcast.patch ./nosetuid.patch ];

  nativeBuildInputs = [autoconf automake libtool pkgconfig];

  buildInputs = [gettext gtk2 libv4l libXext libXtst opencv3 wxgtk];

  meta = {
    description = "A program that produces a familiar, friendly greeting";
    longDescription = ''
      GNU Hello is a program that prints "Hello, world!" when you run it.
      It is fully customizable.
    '';
    homepage = http://www.gnu.org/software/hello/manual/;
    license = stdenv.lib.licenses.gpl3Plus;
    maintainers = [ stdenv.lib.maintainers.eelco ];
    platforms = stdenv.lib.platforms.all;
  };
}
