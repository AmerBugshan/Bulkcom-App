# Bulkom-App 

**Bulkom** is a mobile app that connects users who are interested in purchasing products from China. The app allows people to join group orders, and once a minimum number of users is reached, the products are shipped together. This group shipping method helps significantly reduce delivery costs for each individual.

### Key Features:

- **Lower shipping costs** by combining multiple orders into one shipment.
- **Organized group buying** for individuals interested in the same products or suppliers.
- **Join or create group orders** based on your interests or shipping needs.

---

## 🚀 Getting Started

### ✅ Prerequisites

Ensure you have the following installed:

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (comes with Flutter)
- Android Studio or Visual Studio Code
- A connected device or emulator

To check if your environment is ready, run:

```bash
flutter doctor
```

---

## 📦 Installation

Clone this repository and navigate to the project directory:

```bash
git clone https://github.com/AmerBugshan/Bulkcom-App.git
cd Bulkcom-App/fundorex-mobile-app
```

Get the dependencies:

```bash
flutter pub get
```

---

## ⚙️ Configuration

Update any required configuration values inside the app such as API base URLs, keys, or other constants. Look inside:

- `lib/view/utils/config.dart`
- `.env` file (if applicable)

---

## ▶️ Running the App

To run the app on your connected device or emulator:

```bash
flutter run
```

To run on a specific platform:

```bash
flutter run -d chrome         # Web
flutter run -d android        # Android
flutter run -d ios            # iOS (macOS only)
```

---

## 🛠️ Build

Build APK:

```bash
flutter build apk --release
```

Build for Web:

```bash
flutter build web
```

