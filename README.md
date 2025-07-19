# Caregiver App

A Flutter application with Firebase Phone Authentication for Singapore users, featuring caretakee profile management.

## Features

- 📱 Phone number authentication with Singapore (+65) as default country code
- 🔐 OTP verification
- 👥 Profile selection for multiple caretakees
- 🏠 Personalized home screen showing selected caretakee
- 🔄 Automatic authentication state management
- 🚪 Logout functionality
- 👤 Profile switching capability

## App Flow

1. **Phone Authentication**: Users log in with their phone number
2. **Profile Selection**: After login, users select which caretakee they're caring for
3. **Personalized Home**: Home screen displays the selected caretakee's information
4. **Profile Management**: Users can switch between different caretakee profiles

## Setup Instructions

### 1. Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select an existing one
3. Enable Authentication and set up Phone authentication:
   - Go to Authentication > Sign-in method
   - Enable Phone authentication
   - Add your domain to authorized domains if needed

### 2. Configure Firebase for Flutter

1. Install Firebase CLI:
   ```bash
   npm install -g firebase-tools
   ```

2. Login to Firebase:
   ```bash
   firebase login
   ```

3. Install FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. Configure Firebase for your project:
   ```bash
   flutterfire configure
   ```

   This will:
   - Select your Firebase project
   - Generate `firebase_options.dart` with your project's configuration
   - Configure platform-specific settings

### 3. Platform-specific Setup

#### Android
- The `flutterfire configure` command automatically adds the necessary configuration
- Ensure minimum SDK version is 21 or higher in `android/app/build.gradle`

#### iOS
- The `flutterfire configure` command automatically adds the necessary configuration
- Ensure minimum iOS deployment target is 11.0 or higher

### 4. Run the App

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration (generated)
├── services/
│   └── auth_service.dart     # Authentication service
└── screens/
    ├── auth_wrapper.dart     # Authentication state wrapper
    ├── phone_login_screen.dart   # Phone number input screen
    ├── otp_verification_screen.dart  # OTP verification screen
    └── home_screen.dart      # Main app screen after login
```

## Dependencies

- `firebase_core`: Firebase SDK
- `firebase_auth`: Firebase Authentication
- `intl_phone_field`: International phone number input field

## Usage

1. Launch the app
2. Enter your Singapore phone number (country code +65 is pre-selected)
3. Tap "Send OTP"
4. Enter the 6-digit verification code received via SMS
5. Access the main app interface

## Notes

- The app is configured for Singapore phone numbers by default
- Phone numbers are validated and formatted automatically
- Authentication state is persisted across app restarts
- Users can logout and login with different phone numbers

## Development

To modify the default country code or add additional features:

1. Edit `phone_login_screen.dart` to change the `initialCountryCode`
2. Customize the UI themes in `main.dart`
3. Add new screens and navigation as needed

## Tech Stack

### UI Development
- https://www.flutterflow.io/
- Flutter Tailwind
- Material 3 
- Riverpod
- Flutter_form_builder
- go_router
- dio (HTTP requests)

### Backend
- Node.js backend
- Postgresdb

### Auth
- Firebase Auth

### Push Notifications
- Firebase cloud messaging

### Deployment
- Testflight (iOS)
- Play Console (Android)


