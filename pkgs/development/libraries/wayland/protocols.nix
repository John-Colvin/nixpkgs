{ lib, stdenv, fetchurl
, pkg-config
, meson, ninja, wayland-scanner
, python3, wayland
}:

stdenv.mkDerivation rec {
  pname = "wayland-protocols";
  version = "1.23";

  doCheck = stdenv.hostPlatform == stdenv.buildPlatform;

  src = fetchurl {
    url = "https://wayland.freedesktop.org/releases/${pname}-${version}.tar.xz";
    sha256 = "0xizccackgwszjhlq7jjiv2z2gwppljx0w32ga91bxlnby8z22kc";
  };

  postPatch = lib.optionalString doCheck ''
    patchShebangs tests/
  '';

  depsBuildBuild = [ pkg-config ];
  nativeBuildInputs = [ meson ninja wayland-scanner ];
  checkInputs = [ python3 wayland ];

  mesonFlags = [ "-Dtests=${lib.boolToString doCheck}" ];

  meta = {
    description = "Wayland protocol extensions";
    longDescription = ''
      wayland-protocols contains Wayland protocols that add functionality not
      available in the Wayland core protocol. Such protocols either add
      completely new functionality, or extend the functionality of some other
      protocol either in Wayland core, or some other protocol in
      wayland-protocols.
    '';
    homepage    = "https://gitlab.freedesktop.org/wayland/wayland-protocols";
    license     = lib.licenses.mit; # Expat version
    platforms   = lib.platforms.linux;
    maintainers = with lib.maintainers; [ primeos ];
  };

  passthru.version = version;
}
