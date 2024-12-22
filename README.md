# flutter-sprintinio

## Getting Started

These instructions will guide you through setting up the project on your local machine for development and testing purposes.

### Prerequisites

Before starting, ensure you have the following installed:
- Flutter SDK 3.19.3
- Dart SDK 3.3.1
- Visual Studio Code (VS Code), with Flutter and Dart extensions OR Android Studio with Flutter plugin OR IntelliJ IDEA with Flutter plugin
- Firebase CLI

### Setup

Follow these steps to set up the project:

### 1. **Clone the Repository**

   Clone the repository to your local machine:
   ```bash
   git clone https://github.com/appinioGmbH/flutter-sprintinio.git
   ```

### 2. **Navigate to the Project Directory**

   Change to the repository directory, which contains the Flutter project:
   ```bash
   cd flutter-sprintinio
   ```

### 3. **Get Dependencies**

   Fetch the project's dependencies:
   ```bash
   flutter pub get
   ```


### 4. **Initialize Firebase in Your Project**

To configure Firebase for your Flutter web app, use the FlutterFire CLI:

- **Run Configuration Command**: Navigate to your project directory in the terminal and execute:
  ```bash
  dart pub global activate flutterfire_cli
  flutterfire configure
  ```
- **Select Platform and Services**:
  - When prompted, choose the **web** platform.
  - Select your Firebase project and any required services. This process generates the `firebase_options.dart` file tailored for the web.
- **Verify File Location**: Check that `firebase_options.dart` is placed correctly in your project's `lib` folder:
  ```bash
  ls -l lib/firebase_options.dart
  ```

## Running the Development Environment

To run the project with hot reload functionality:

1. **Start the Development Server**

   Launch the project in your web browser (Chrome by default) with:
   ```bash
   flutter run -d chrome --web-port=5000
   ```
   This will start the development server and open your application in the browser.

2. **Using Hot Reload**

   With hot reload, you can instantly see the changes you make in the app:
   - Press the `r` key in the terminal where your app is running to perform a hot reload.
   - If using VS Code, saving your files can also trigger a hot reload, depending on your setup.

3. **Using Firestore Locally for Testing Purposes**

   - Run the following command in the terminal to start the Firestore emulator:
     ```bash
     firebase emulators:start
     ```
   - Configure your app to connect to the emulator:
     ```dart
     const bool kDebugMode = !kReleaseMode && !kProfileMode;
     if (kDebugMode) {
       FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
       await FirebaseAuth.instance.useAuthEmulator('localhost', 9099, automaticHostMapping: false);
     }
     ```