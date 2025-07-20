import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:url_strategy/url_strategy.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';
import 'screens/phone_login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/profile_selection_screen.dart';
import 'screens/firestore_test_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Configure URL strategy for web
  if (kIsWeb) {
    // Use path URL strategy for better GitHub Pages compatibility
    setPathUrlStrategy();
  }
  
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caregiver App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const PhoneLoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/profiles': (context) => const ProfileSelectionScreen(),
        '/firestore-test': (context) => const FirestoreTestScreen(),
      },
    );
  }
}
