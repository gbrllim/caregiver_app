# Firebase Setup Guide

## Quick Setup Instructions

### 1. Install Firebase CLI
```bash
npm install -g firebase-tools
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Install and Run FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
export PATH="$PATH":"$HOME/.pub-cache/bin"
flutterfire configure
```

### 4. Enable Phone Authentication
1. Go to Firebase Console → Your Project
2. Authentication → Sign-in method
3. Enable "Phone" authentication
4. Add test phone numbers if needed for development

### 5. Configure App Check (Optional but Recommended)
1. Go to Firebase Console → Your Project → App Check
2. Register your app for App Check
3. This helps prevent abuse of your Firebase resources

## Important Notes

- Replace the placeholder values in `firebase_options.dart` with your actual Firebase project configuration
- For production apps, make sure to configure App Check and set up proper security rules
- Test phone authentication thoroughly before deploying

## Testing

- Use Firebase Console to add test phone numbers for development
- Test the complete flow: phone input → OTP → verification → login
- Test logout functionality and re-authentication
