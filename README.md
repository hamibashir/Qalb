<div align="center">
  <h1>🕌 Qalb - Islamic App</h1>
  <p><strong>A comprehensive Islamic application built with Flutter and Laravel</strong></p>
  
  [![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
  [![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)](https://laravel.com/)
  [![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
  [![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)](https://php.net/)
</div>

<br />

## 📖 Overview

Welcome to the **Qalb** repository! Qalb is a fully-featured Islamic mobile application accompanied by a robust web backend. It is designed to provide users with accurate prayer times, Qibla direction, Quran recitation, Hijri calendar, and more, seamlessly integrated across a modern tech stack.

---

## ✨ Key Features

- **🕋 Accurate Prayer Times & Qibla**: Built-in compass and geolocation for precise timings and direction.
- **📖 Quran & Audio**: High-quality audio playback and background services for recitation.
- **📅 Hijri Calendar**: Integrated Islamic calendar dates and events.
- **🔔 Prayer Notifications**: Reliable local notifications and timezone support for Adhan alerts.
- **💳 Donation/Payments**: Secure payment integrations including Stripe, PayPal, Razorpay, and Paystack.
- **🌍 Multi-language Support**: Easily switch between languages for a localized experience.
- **📱 Cross-platform App**: A single codebase for Android and iOS built with Flutter.
- **⚙️ Powerful Backend**: A scalable, API-driven backend powered by Laravel.

---

## 🛠️ Tech Stack

### Mobile App (Flutter)
- **Framework**: [Flutter](https://flutter.dev/)
- **Language**: [Dart](https://dart.dev/)
- **State Management**: [GetX](https://pub.dev/packages/get)
- **Key Packages**: `just_audio`, `flutter_qiblah`, `flutter_local_notifications`, `google_maps_flutter`

### Backend (Laravel)
- **Framework**: [Laravel](https://laravel.com/)
- **Language**: [PHP](https://php.net/)
- **Database**: MySQL / PostgreSQL
- **Asset Bundler**: [Vite](https://vitejs.dev/)

---

## 🚀 Getting Started

Follow these instructions to set up the project locally for both the mobile app and the backend.

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install)
- [Node.js](https://nodejs.org/) & NPM
- [PHP](https://www.php.net/) & [Composer](https://getcomposer.org/)

### Mobile App Setup
1. **Navigate to the app directory:**
   ```bash
   cd app
   ```
2. **Install dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run the app:**
   ```bash
   flutter run
   ```

### Backend Setup
1. **Navigate to the web directory:**
   ```bash
   cd web
   ```
2. **Install PHP and Node dependencies:**
   ```bash
   composer install
   npm install
   ```
3. **Setup environment variables:**
   ```bash
   cp .env.example .env
   php artisan key:generate
   ```
4. **Run the development server:**
   ```bash
   php artisan serve
   ```
   *In a separate terminal:*
   ```bash
   npm run dev
   ```

---

## 📂 Project Structure

```text
Qalb/
├── app/                # Flutter Mobile Application
│   ├── android/        # Android specific code
│   ├── ios/            # iOS specific code
│   ├── lib/            # Main Dart source code
│   └── pubspec.yaml    # Flutter dependencies
│
└── web/                # Laravel Backend & Web Interface
    ├── app/            # Laravel application code (Controllers, Models)
    ├── routes/         # API and Web routes
    ├── src/            # Frontend source assets
    └── composer.json   # PHP dependencies
```

---

<div align="center">
  <p>Built with ❤️ for the Ummah.</p>
</div>
