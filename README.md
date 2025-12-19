# Sandwich Shop

This is a simple Flutter app that allows users to order sandwiches.
The app is built using Flutter and Dart, and it is designed primarily to be run in a web
# Sandwich Shop

This repository contains a small Flutter sandwich-ordering app used for learning and testing
integration scenarios. The README below focuses on setup, test guidance, and build steps
you'll need to reproduce the worksheet tasks and demonstrate the app to staff for sign-off.

**Quick summary:**
- The integration tests are in `integration_test/app_test.dart` and include additional
    user journeys for removing items, decrementing to zero, and verifying the empty cart UI.
- This guide includes commands to run tests and build debug/release Windows bundles.

**Note:** Use PowerShell on Windows for the commands below (I've run these locally).

**Prerequisites**
- **Flutter SDK**: verify with `flutter doctor`.
- **Visual Studio (with C++ workload)** for Windows desktop builds. If you have a modern
    Visual Studio (2022/2026), upgrade Flutter to the latest stable release so the toolchain
    detects it correctly (`flutter upgrade`).
- **Git**: `git --version`.

**Get the code**
```powershell
git clone --branch 8 https://github.com/manighahrmani/sandwich_shop
cd sandwich_shop
code .
```

**Install dependencies**
```powershell
flutter pub get
```

**Run the app (development)**
```powershell
flutter run
```

**Integration tests added**
- File: `integration_test/app_test.dart` — added tests that cover:
    - Removing an item using the delete icon and verifying cart empties.
    - Decrementing quantity to zero removes the item.
    - Opening the cart with no items shows the empty-state message and hides `Checkout`.

Run the integration tests on Windows desktop:
```powershell
flutter test -d windows integration_test/app_test.dart
```

If multiple devices are connected, specify the device ID with `-d <deviceId>`.

**Build (Windows)**
Create debug and release builds for comparison.

Debug build:
```powershell
flutter build windows --debug
```

Release build:
```powershell
flutter build windows --release
```

After building you will find bundles under:
- `build\windows\x64\runner\Debug`
- `build\windows\x64\runner\Release`

**Observed size comparison (example from a local run)**
- Debug total folder size: `~128.83 MB` (`build\windows\x64\runner\Debug`)
- Release total folder size: `~61.47 MB` (`build\windows\x64\runner\Release`)

Notes on difference:
- Debug includes developer artifacts (PDB symbols, `kernel_blob.bin`) and an unoptimized
    runtime; it is significantly larger.
- Release contains AOT snapshot `app.so` and a smaller `flutter_windows.dll`; this reduces
    runtime size and improves startup performance.

**Run the release app (Windows)**
```powershell
Start-Process -FilePath .\build\windows\x64\runner\Release\sandwich_shop.exe
```

**What to show staff for sign-off**
- The updated `integration_test/app_test.dart` file — explain the new tests and why they
    cover important user journeys (removal, decrement-to-zero, empty state).
- Run the integration tests and show the passing results (or paste the console output).
- Show the release executable running on Windows (or provide a short screen recording).
- Share the `README.md` (this file) with the steps you followed.

**Troubleshooting**
- If CMake fails to detect Visual Studio (common on Windows), try:
    - Ensure Visual Studio has the "Desktop development with C++" workload installed.
    - Upgrade Flutter to the latest stable version: `flutter upgrade`.
    - If Flutter still tries to use an older generator, set the environment for the session:
        ```powershell
        $env:CMAKE_GENERATOR = 'Visual Studio 17 2022'
        ```

**Commands summary (copyable)**
```powershell
# install deps
flutter pub get

# run app (dev)
flutter run

# run integration tests on Windows
flutter test -d windows integration_test/app_test.dart

# debug and release builds
flutter build windows --debug
flutter build windows --release

# run release exe
Start-Process -FilePath .\build\windows\x64\runner\Release\sandwich_shop.exe
```

If you want, I can also commit these changes and open a pull request for you to share with staff.

## Building and comparing debug vs release (Windows)

I created both a debug and a release build and recorded sizes. Commands used:

```powershell
flutter build windows --debug
flutter build windows --release
```

- Debug build total size: 128.83 MB (build\windows\x64\runner\Debug)
- Release build total size: 61.47 MB (build\windows\x64\runner\Release)

Observations:
- The debug build contains additional developer artifacts (PDB, kernel_blob, larger `flutter_windows.dll`) and is roughly ~2x larger than the release build.
- The release build is much smaller and contains an `app.so` (AOT snapshot) plus a smaller `flutter_windows.dll`.

To run the produced release executable on Windows:

```powershell
Start-Process -FilePath .\build\windows\x64\runner\Release\sandwich_shop.exe
```

Show these updated tests and this README to a member of staff for sign-off as requested in the worksheet.

## Get support

Use [the dedicated Discord channel](https://discord.com/channels/760155974467059762/1370633732779933806)
to ask your questions and get help from the community.
Please provide as much context as possible, including the error messages you are seeing and
screenshots (you can open Discord in your web browser).
