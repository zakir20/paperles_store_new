# Paperless Store (Updated)

A professional store management application built with **Flutter** using **Clean Architecture** and **Cubit** state management.

## 🚀 Project Overview
This project is designed to handle store operations like user registration, authentication, and inventory management, connected to a local PHP/MySQL backend.

## 🛠 Tech Stack
- **Frontend:** Flutter (Dart)
- **State Management:** Bloc/Cubit
- **Navigation:** GoRouter
- **Localization:** Easy Localization (JSON based)
- **Networking:** Dio with Network Executor pattern
- **Dependency Injection:** GetIt (Service Locator)
- **Backend:** PHP & MySQL

## 📁 Key Features Implemented
- **Full Auth Module:** Split Login and Registration logic for better modularity.
- **Repository Pattern:** Separated domain and data layers for a scalable architecture.
- **Global Auth:** Persistent session management (Auto-login) using SharedPreferences.
- **Dynamic Localization:** Support for English and Bangla.
- **Custom UI:** Mobile-first design using global theme colors and responsive layouts.

## ⚙️ Development Setup
1. Ensure a local server (XAMPP/WAMP) is running.
2. Configure the `baseUrl` in `dio_client.dart` with your machine's local IP address.
3. Run `flutter pub get` to install dependencies.
4. Run `flutter run`.