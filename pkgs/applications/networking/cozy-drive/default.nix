{ lib
, fetchurl
, appimageTools
}:

let
  pname = "cozydrive";
  version = "3.30.1";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://github.com/cozy-labs/cozy-desktop/releases/download/v${version}/Cozy-Drive-${version}-x86_64.AppImage";
    sha256 = "06w305l5iadd4k70jvrvw2scwlfxycign2nz0f2vrwwhqy8bpfqs";
  };
  appimageContents = appimageTools.extract { inherit name src; };

in
appimageTools.wrapType2 {
  inherit name src;
  extraInstallCommands = ''
    mv $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/cozydrive.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/cozydrive.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cozy Drive is a synchronization tool for your files and folders with Cozy Cloud.";
    homepage = "https://cozy.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ "Simarra" ];
    platforms = [ "x86_64-linux" ];
  };
}
