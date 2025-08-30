import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Align(
                alignment: Alignment.centerLeft, // pushes it to the left
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
          _SearchBar(hint:'Search recipes, ingredients,or products'),
          const SizedBox(height: 16),
          _ChipsRow(
            selectedIndex: _selectedChip,
            onSelected: (int i) => setState(() => _selectedChip = i),
            selectedColor: brandGreen,
          ),
                     const SizedBox(height: 16),
           // Featured Recipes Section
           _FeaturedRecipesSection(),
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

class _ChipsRow extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final Color selectedColor;

  const _ChipsRow({required this.selectedIndex, required this.onSelected, required this.selectedColor});

  @override
  Widget build(BuildContext context) {
    final List<String> labels = <String>['All Recipes', 'Trending', 'Quick & Easy', 'Seasonal'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List<Widget>.generate(labels.length, (int index) {
          final bool isSelected = index == selectedIndex;
          return Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 12),
            child: ChoiceChip(
              label: Text(labels[index]),
              selected: isSelected,
              onSelected: (_) => onSelected(index),
              selectedColor: selectedColor,
              backgroundColor: const Color(0xFFF0F1F2),
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
              side: BorderSide(color: Colors.black.withOpacity(0.05)),
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
          );
        }),
      ),
    );
  }
}

class _FeaturedRecipesSection extends StatelessWidget {
  const _FeaturedRecipesSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with "See All" link
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Featured Recipes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A3D4D),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to all recipes
              },
              child: Text(
                'See All',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF7B8B57),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        
        // Featured Recipe Card
        _FeaturedRecipeCard(),
      ],
    );
  }
}

class _FeaturedRecipeCard extends StatelessWidget {
  const _FeaturedRecipeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Recipe Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage('https://example.com/salmon-recipe.jpg'), // API image URL
                fit: BoxFit.cover,
              ),
            ),
            child: Stack(
              children: [
                // Category Tag
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF7B8B57),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Main Course', // API data
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // Favorite Icon
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border,
                      size: 20,
                      color: Color(0xFF4A3D4D),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Recipe Information
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Title
                Text(
                  'Herb-Crusted Salmon with Olive Oil', // API data
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3D4D),
                  ),
                ),
                const SizedBox(height: 8),
                
                // Recipe Description
                Text(
                  'Fresh Atlantic salmon with our signature herb blend and premium olive oil, creating a restaurant-quality dish at home.', // API data
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Rating and Shop Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Rating
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '4.8', // API data
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4A3D4D),
                          ),
                        ),
                      ],
                    ),
                    
                    // Shop Ingredients Button
                    ElevatedButton.icon(
                      onPressed: () {
                        // Navigate to shop ingredients
                      },
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text(
                        'Shop Ingredients',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B8B57),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


