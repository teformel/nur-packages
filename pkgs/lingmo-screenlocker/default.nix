{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, kdePackages, qt6, xorg, pam }:

stdenv.mkDerivation rec {
  pname = "lingmo-screenlocker";
  version = "main";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-screenlocker";
    rev = "d16aa1d2b2cb39489da4f2bbda06422cac09ec16";
    hash = "sha256-6GjkyC5BhXAuO7lqMcw+eXtKHLkfnQx6AUTRclVulu8=";
  };

  postPatch = ''
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION "/usr/|DESTINATION "|g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION "/etc/|DESTINATION "etc/|g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /usr/|DESTINATION |g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /etc/|DESTINATION etc/|g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /etc|DESTINATION etc|g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|''${QT_PLUGINS_DIR}|lib/qt-6/plugins|g' {} +

    # Try to build with Qt6 instead of Qt5
    find . -name "CMakeLists.txt" -exec sed -i 's/Qt5/Qt6/g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's/KF5/KF6/g' {} +
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.wrapQtAppsHook
    kdePackages.extra-cmake-modules
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qttools
    xorg.libX11
    pam
  ];
}
