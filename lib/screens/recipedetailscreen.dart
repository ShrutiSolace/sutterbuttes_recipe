// lib/screens/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../modal/rating_model.dart';
import '../modal/recipe_model.dart';
import '../repositories/rating_repository.dart';

class RecipeDetailScreen extends StatelessWidget {
  final RecipeItem recipe;

  const RecipeDetailScreen({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          recipe.title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
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
                  FutureBuilder<RatingsModel>(
                    future: RatingsRepository().getRecipeRatings(recipe.id),
                    builder: (context, snapshot) {
                      String ratingText = '0.0';
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        ratingText = 'Loading...';
                      } else if (snapshot.hasData) {
                        ratingText = snapshot.data!.average.toStringAsFixed(1);
                      }

                      return Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            ratingText,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4A3D4D),
                            ),
                          ),
                        ],
                      );
                    },
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
                      "img": Style(
                        display: Display.none, // Hide all images
                      ),
                      "h1": Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        margin: Margins.only(top: 24, bottom: 16),
                      ),
                      "h2": Style(
                        fontSize: FontSize(18),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        margin: Margins.only(top: 20, bottom: 12),
                      ),
                      "h3": Style(
                        fontSize: FontSize(16),
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                        margin: Margins.only(top: 16, bottom: 12),
                      ),
                      "p": Style(
                        fontSize: FontSize(16),
                        color: Colors.grey[800],
                        margin: Margins.only(top: 8, bottom: 12),
                        padding: HtmlPaddings.zero,
                      ),
                      "ul": Style(
                        padding: HtmlPaddings.only(left: 20), // Add left padding for bullets
                        margin: Margins.only(top: 8, bottom: 16), // Add top and bottom margin
                      ),
                      "ol": Style(
                        padding: HtmlPaddings.only(left: 20), // Add left padding for bullets (same as ul)
                        margin: Margins.only(top: 8, bottom: 16), // Add top and bottom margin
                      ),
                      "li": Style(
                        padding: HtmlPaddings.only(left: 8, bottom: 8), // Spacing for list items
                        margin: Margins.zero,
                        fontSize: FontSize(16),
                        color: Colors.grey[800],
                        listStyleType: ListStyleType.disc, // Force bullet points on ALL list items (ul and ol)
                        display: Display.listItem, // Proper list item display
                      ),
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