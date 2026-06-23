{ stdenv
, lib
, fetchFromGitHub
, cmake
, pkg-config
, kdePackages
, qt6
, libcanberra
, sound-theme-freedesktop
, libpulseaudio
}:

stdenv.mkDerivation rec {
  pname = "lib_lingmo";
  version = "main";

  src = fetchFromGitHub {
    owner = "LingmoOS";
    repo = "lib_lingmo";
    rev = "8e925c48bde97d0fc0dc951e736dbb010c71ee60";
    hash = "sha256-R7d+w6f4Qh5kH0O1R8+x4JcR4gVpC8J9Q4n9mN5I/n4=";
  };

  postPatch = ''
    sed -i 's/set(CMAKE_CXX_STANDARD 17)/set(CMAKE_CXX_STANDARD 20)/g' CMakeLists.txt
    
    # 彻底拦截 ecm_query_qt 覆盖安装路径的行为
    sed -i 's/ecm_query_qt(INSTALL_QMLDIR QT_INSTALL_QML)/set(INSTALL_QMLDIR "\$\{CMAKE_INSTALL_PREFIX\}\/lib\/qt-6\/qml")/g' CMakeLists.txt
    
    # 修复写死的 Qt5
    if [ -f "system/CMakeLists.txt" ]; then
      sed -i 's/find_package(Qt5 REQUIRED COMPONENTS DBus)/find_package(Qt6 REQUIRED COMPONENTS DBus)/g' system/CMakeLists.txt
    fi
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsensors
    kdePackages.bluez-qt
    kdePackages.networkmanager-qt
    kdePackages.modemmanager-qt
    kdePackages.libkscreen
    kdePackages.kio
    libcanberra
    sound-theme-freedesktop
    libpulseaudio
  ];

  cmakeFlags = [
    "-DCMAKE_CXX_STANDARD=20"
    "-DCMAKE_CXX_STANDARD_REQUIRED=ON"
  ];

  env.CXXFLAGS = "-std=c++20";
}
