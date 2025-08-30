import 'package:flutter/material.dart';

class RecipesScreen extends StatelessWidget {
  const RecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Natural and Artisan Foods',
          style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ),
      body: const _RecipesHeader(),
    );
  }
}

class _RecipesHeader extends StatelessWidget {
  const _RecipesHeader();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                             Expanded(
                 child: Image.asset(
                   'assets/images/homescreen logo.png',
                   height: 100,
                   fit: BoxFit.contain,
                 ),
               ),
              Row(
                children: const <Widget>[
                  Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                  SizedBox(width: 16),
                  Icon(Icons.notifications_none, color: Colors.black87),
                  SizedBox(width: 16),
                  Icon(Icons.person_outline, color: Colors.black87),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const _SearchBar(hint: 'Search recipes, ingredients, or products...'),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  const _SearchBar({required this.hint});

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.15)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.black.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF7B8B57)),
        ),
      ),
    );
  }
}


