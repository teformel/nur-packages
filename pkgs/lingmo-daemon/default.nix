{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, libsForQt5, qt5 }:

stdenv.mkDerivation rec {
  pname = "lingmo-daemon";
  version = "main";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-daemon";
    rev = "610162449954c5ac12eca33493f7c9fe211cb5c0";
    # TODO: 首次构建将报错，请将报错提供的 Hash 填入此处
    hash = "sha256-Ix9PC0tr9zkLvqjj/UqnpbZ7R60ga9rgIh2kqgLwok4=";
  };

    postPatch = ''
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /usr/|DESTINATION |g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /etc/|DESTINATION etc/|g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /etc|DESTINATION etc|g' {} +
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.extra-cmake-modules
    libsForQt5.wrapQtAppsHook
    qt5.qttools
  ];

  buildInputs = [
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtsvg
    qt5.qtwayland
    libsForQt5.kcoreaddons
    libsForQt5.kwindowsystem
  ];
}
