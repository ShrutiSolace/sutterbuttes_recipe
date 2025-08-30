import 'package:flutter/material.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed('/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Welcome line above logo
              Text(
                '!!!!Welcome!!!!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w300,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 1.2,
                  color: Colors.black,
                  fontFamily: 'Playfair Display',
                ),
              ),
              const SizedBox(height: 8),
              Image.asset(
                'assets/images/Splash sceen logo.jpg',
                height: 150,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 16),
              Text(
                'Cook, Shop & Savor.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  fontStyle: FontStyle.italic,
                  letterSpacing: 0.8,
                  color: const Color(0xFF4A3D4D),
                  fontFamily: 'Playfair Display',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


