import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/bottom_navigation.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print('Starting Firebase initialization...');

  try {
    await Firebase.initializeApp();
    print(' Firebase initialized successfully!');
    print(' Firebase app name: ${Firebase.app().name}');
    print(' Firebase options: ${Firebase.app().options}');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sutter Buttes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const BottomNavigationScreen(),
        '/signup': (BuildContext context) => const SignupScreen(),
        '/login': (BuildContext context) => const LoginScreen(),

      },
    );
  }
}

// Removed the default counter screen and replaced it with BottomNavigationScreen as the app home.
