# Stock Tracker

A cross-platform mobile app built with Flutter for tracking stocks, viewing price charts, news feeds, and managing a personal watchlist.

## Features

- User registration and login
- View stock prices and charts
- News feed for stock market updates
- Add/remove stocks to your watchlist
- Firebase authentication and Firestore integration

## Getting Started

### Prerequisites

- Flutter SDK
- Dart
- Firebase project (with authentication and Firestore enabled)

### Installation

1. Clone the repository:
   ```sh
   git clone https://github.com/courtneyleora/Stock-Tracker.git
   ```
2. Navigate to the project directory:
   ```sh
   cd Stock-Tracker
   ```
3. Install dependencies:
   ```sh
   flutter pub get
   ```
4. Configure Firebase:
   - Add your `google-services.json` to `android/app/`
   - Add your `GoogleService-Info.plist` to `ios/Runner/`

### Running the App

- For Android:
  ```sh
  flutter run
  ```
- For iOS:
  ```sh
  flutter run
  ```

## Project Structure

- `lib/` - Main Dart code
  - `screens/` - UI screens (registration, login, main, news feed, price chart, watchlist)
  - `firebase_options.dart` - Firebase configuration
- `android/` and `ios/` - Platform-specific files
- `pubspec.yaml` - Dependencies
