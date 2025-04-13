# autosense_app

This project contains the flutter frontend for a mobile application that can view, add, update and delete stations on a map.
Since the backend [REST API]() is not live and needs to be run locally, this application, likewise, needs to run locally
on an emulator on the same machine as the API. This app was developed and tested on Android, therefore to ensure reliability
you should run the application on an Android emulator.

## Requirements

* [Flutter](https://docs.flutter.dev/get-started/install)
* [Android Studio](https://developer.android.com/studio)

## Getting Started

### 1. From APK

[Download](https://github.com/fmanana/autosense_frontend/releases/download/v0.0.1/app-debug.apk) the APK file into an
emulator and run the application.

### 2. From Source

Alternatively, to build the application from source, clone the repo:
```bash
git clone https://github.com/fmanana/autosense_frontend
```

#### Install Dependencies

To install the flutter dependencies run the following command:
```bash
flutter pub get
```

#### Run the App

With the emulator running, run the following command:
```bash
flutter run
```