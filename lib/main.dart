import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/bottom_navigation.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
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
