{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, kdePackages, qt6, lingmoui, lingmo-core, lib_lingmo }:

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
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
    qt6.qttools
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
    kdePackages.kcoreaddons
    kdePackages.kwindowsystem
    lingmoui
    lingmo-core
    lib_lingmo
  ];
}




