import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/screens/trending_recipe_detail_screen.dart';

import '../modal/trending_recipes_model.dart';
import '../repositories/recipe_list_repository.dart';


class AllTrendingRecipesScreen extends StatelessWidget {
  const AllTrendingRecipesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trending This Week'),
        backgroundColor: const Color(0xFF4A3D4D),
        foregroundColor: Colors.white, // makes back arrow and icons white
        titleTextStyle: const TextStyle(
          color: Colors.white, // title text color
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),

        body: FutureBuilder<TrendingRecipesModel>(
        future: RecipeListRepository().getTrendingRecipes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load trending recipes'));
          }

          final items = snapshot.data?.recipes ?? <Recipes>[];
          if (items.isEmpty) {
            return const Center(child: Text('No recipes found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final r = items[index];
              return _TrendingRecipeListItem(
                title: r.title ?? '',
                description: r.excerpt ?? '',
                rating: (r.rating != null && r.rating!.isNotEmpty)
                    ? double.tryParse(r.rating!) ?? 0.0
                    : 0.0,
                imageUrl: r.image ?? '',
              );
            },
          );
        },
      ),


    );
  }
}
class _TrendingRecipeListItem extends StatelessWidget {
  final String title;
  final String description;
  final double rating;
  final String imageUrl;

  const _TrendingRecipeListItem({
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // ✅ Navigate to your details screen here
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TrendingRecipeDetailsScreen(
              title: title,
              description: description,
              rating: rating,
              imageUrl: imageUrl,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Row(
          children: [
            // Image
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius:
                const BorderRadius.horizontal(left: Radius.circular(16)),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3D4D),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
