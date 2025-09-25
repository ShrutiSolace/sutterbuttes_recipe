import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/cart_provider.dart';
import 'bottom_navigation.dart';

class OrderSuccessScreen extends StatelessWidget {
  const OrderSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(color: const Color(0xFFE8FFF1), shape: BoxShape.circle),
                child: const Icon(Icons.check, color: Colors.green, size: 48),
              ),
              const SizedBox(height: 24),
              const Text('Order Placed Successfully!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF4A3D4D))),
              const SizedBox(height: 12),
              const Text('Thank you for your order. You will receive a confirmation email shortly.',
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 14)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  await context.read<CartProvider>().loadCart();
                  // Go home
                  if (context.mounted) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const BottomNavigationScreen()),
                      (route) => false,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B8B57), padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                child: const Text('Continue Shopping', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



