# chatApp (Qt/QML Frontend)

Adhoc chat frontend UI built with Qt 6 (Qt Quick / QML), inspired by the ChitChatter layout.

## Requirements

On Ubuntu/Debian:

```bash
sudo apt update
sudo apt install -y cmake ninja-build build-essential \
  qt6-base-dev qt6-declarative-dev \
  qml6-module-qtquick qml6-module-qtquick-controls \
  qml6-module-qtquick-layouts qml6-module-qtqml-workerscript
```

## Build

```bash
cd /home/ahmed-nasir/Desktop/chatApp
cmake -S . -B build -G Ninja
cmake --build build
```

## Run

```bash
./build/appchatApp
```

## Clean Rebuild

```bash
rm -rf build
cmake -S . -B build -G Ninja
cmake --build build
```

## Troubleshooting

### 1) Could not find a package configuration file provided by "Qt6"

Qt development packages are missing. Install:

```bash
sudo apt install -y qt6-base-dev qt6-declarative-dev
```

### 2) QML module/plugin errors at runtime

Make sure declarative runtime/dev packages are installed:

```bash
sudo apt install -y qt6-declarative-dev
```

Then rebuild from scratch (see Clean Rebuild).

### 3) Binary not found (./build/appchatApp: No such file or directory)

List the build directory:

```bash
ls build
```

Then run the executable name shown there.
