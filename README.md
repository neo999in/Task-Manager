<div align="center">
  <h1>Task Manager</h1>
  <img src="https://img.icons8.com/fluency/120/task.png" alt="Task Manager Logo" width="120" height="120" /><br /><br />
<a href="#"><img src="https://img.shields.io/badge/Download-APK-2D80EC?logo=android" width="226" ></a><br><br>
</div>

---
### 📖 Description

**Task Manager** is a sleek, modern mobile and web dashboard built with Flutter to help you streamline and master your daily productivity. It leverages the real-time performance of **Firebase** to deliver secure user authentication and seamless task synchronization. With modern components including a dynamic **status tracking system** and fully modifiable **due dates**, Task Manager packs essential features into a premium, high-performing application.

Additionally, it features a minimalist REST API integration fetching curated daily motivational quotes to keep you inspired every step of your productivity journey.


---

### ✨ Features
- 🔐 **Firebase Authentication**: Secure sign up, login, and integrated user logout flows with password visibility toggle support.
- ☁️ **Real-time Cloud Firestore Sync**: Instant data synchronization across devices. Your tasks are safe, securely partitioned, and dynamically up to date.
- 🎯 **Dynamic Status**: Custom pill-based badges that intelligently flag tasks as **Done**, **Pending**, or **Overdue** in real time.
- 📅 **Integrated Scheduler**: Fully modifiable Task editor featuring native Date and Time selection dialogs.
- 💡 **Minimalist Quote Generator**: Curated motivational quote integration fetching clean JSON packages dynamically via safe REST API calls.
- 🎨 **Premium UI/UX**: A professional Material 3 redesign employing soft shadows, fluid cards, circular action states, and custom empty layouts.

---

### 🚀 Setup Steps

Follow these instructions to set up, configure, and deploy Task Manager on your local machine:

#### 1. Prerequisites
Ensure you have the following installed:
* **Flutter SDK**: `^3.11.4` or higher.
* **Dart SDK**: Pre-bundled with Flutter.
* **IDE**: VS Code or Android Studio.

#### 2. Clone the Repository
```bash
git clone https://github.com/neo999in/Task-Manager.git
cd Task-Manager
```

#### 3. Install Dependencies
Install all the preconfigured package dependencies:
```bash
flutter pub get
```

#### 4. Configure Firebase Integrations
This project relies on Firebase. Make sure you are logged in to the CLI:
```bash
firebase login
dart pub global activate flutterfire_cli
```
Then run the configuration script to generate your native Android config and the dynamic `firebase_options.dart` injector:
```bash
flutterfire configure
```

#### 5. Run the Project
Launch your application locally across your connected device or modern web browser:
```bash
# Run on connected emulator/device
flutter run

```

---

### 🛠 Tech Stack
<a href="https://flutter.dev/"><img src="https://img.shields.io/badge/Flutter-00CCFF?labelColor=333333&logo=Flutter&logoColor=00CCFF" height="30" width="106" align="left"></a>
<a href="https://dart.dev/"><img src="https://img.shields.io/badge/Dart-40C4FF?labelColor=333333&logo=Dart&logoColor=40C4FF" height="30" width="88" align="left"></a>
<a href="https://firebase.google.com/"><img src="https://img.shields.io/badge/Firebase-FFCA28?labelColor=333333&logo=Firebase&logoColor=FFCA28" height="30" width="120" align="left"></a>

<br>

- **Key Ecosystem Packages**:
  - `firebase_auth` (Authentication Layer)
  - `cloud_firestore` (NoSQL Cloud Persistence)
  - `provider` (Clean Architecture State Management)
  - `intl` (Standardized Localization & Date Formatting)
  - `http` (RESTful Endpoint Ingestion)

---

### 📂 Folder Structure
```text
task_manager/
└── lib/                      # Application source code
    ├── models/               # Structured Task data mapping models
    ├── services/             # API, Firebase Auth, and Database access services
    ├── screens/              # Modularized feature views & interactive layouts
    ├── widgets/              # Global reusable UI controls & card components
    ├── firebase_options.dart # Generated multi-platform Firebase configurations
    └── main.dart            # Native runtime initialization & application entry
```