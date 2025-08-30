import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

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
      body: const _HomeHeaderAndContent(),
    );
  }
}

class _HomeHeaderAndContent extends StatefulWidget {
  const _HomeHeaderAndContent();

  @override
  State<_HomeHeaderAndContent> createState() => _HomeHeaderAndContentState();
}

class _HomeHeaderAndContentState extends State<_HomeHeaderAndContent> {
  int _selectedChip = 0;

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF7B8B57);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ✅ My Favorites header at the top
          Row(
            children: const [
              Icon(Icons.favorite, color: Colors.red),
              SizedBox(width: 8),
              Text(
                "My Favorites",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3D4D),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const SizedBox(height: 12),

        ],
      ),
    );
  }
}


