// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../modal/recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeItem recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
        backgroundColor: const Color(0xFF7B8B57),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Recipe Image
            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: (recipe.imageUrl != null && recipe.imageUrl.isNotEmpty)
                      ? NetworkImage(recipe.imageUrl)
                      : const AssetImage("assets/images/homescreen logo.png") as ImageProvider,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title
                  Text(
                    recipe.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Rating
                  Row(
                    children: const [
                      Icon(Icons.star, color: Colors.amber, size: 24),
                      SizedBox(width: 8),
                      Text(
                        '4.8',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4A3D4D),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Shop Ingredients Button
                  ElevatedButton.icon(
                    onPressed: () {

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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recipe Details (Ingredients and Directions)
                  Html(
                    data: (recipe.contentHtml != null && recipe.contentHtml.trim().isNotEmpty)
                        ? recipe.contentHtml
                        : "No description available",
                    style: {
                      "body": Style(
                        padding: HtmlPaddings.all(0),
                        margin: Margins.zero,
                        fontSize: FontSize(16),
                        color: Colors.grey[800],
                      ),
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}