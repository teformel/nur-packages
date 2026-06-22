{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, kdePackages, qt6 }:

stdenv.mkDerivation rec {
  pname = "lingmo-desktop";
  version = "main";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lingmo-desktop";
    rev = "0c2db3a0f856f54a7145a19e6fd0c79fc1e31131";
    hash = "sha256-613S8ofX4vbD6+8FyddxTp6sfd3JshVyI92NVtLOavs=";
  };

  postPatch = ''
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /usr/|DESTINATION |g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /etc/|DESTINATION etc/|g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's|DESTINATION /etc|DESTINATION etc|g' {} +
    
    # Try to build with Qt6 instead of Qt5
    find . -name "CMakeLists.txt" -exec sed -i 's/Qt5/Qt6/g' {} +
    find . -name "CMakeLists.txt" -exec sed -i 's/KF5/KF6/g' {} +
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
    kdePackages.kio
  ];
}
