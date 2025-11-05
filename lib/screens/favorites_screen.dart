import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/screens/recipedetailscreen.dart';
import '../modal/recipe_model.dart';
import '../repositories/favourites_repository.dart';
import '../modal/favourites_model.dart';
import 'package:html/parser.dart' as html_parser;


class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});


  String cleanHtmlText(String text) {
    // Parse the HTML and extract text content (this handles all HTML entities)
    final document = html_parser.parse(text);
    final cleanText = document.body?.text ?? text;

    // Remove any remaining HTML tags
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return cleanText.replaceAll(htmlTagRegex, '').trim();
  }

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

    return FutureBuilder<FavouritesModel>(
      future: FavouritesRepository().getFavourites(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Failed to load favourites'));
        }
        final favourites = snapshot.data;
        final recipeItems = favourites?.favorites?.recipes ?? <Recipes>[];
        final productItems = favourites?.favorites?.products ?? <Products>[];

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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

              if (recipeItems.isNotEmpty) ...[
                const Text(
                  'Favorite Recipes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4A3D4D)),
                ),
                const SizedBox(height: 10),
                GridView.builder(

                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: recipeItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75, // Adjust height/width ratio
                  ),
                  padding: const EdgeInsets.all(2),
                  itemBuilder: (context, index) {
                    final r = recipeItems[index];
                    return _FavoriteCard(
                      title: r.title ?? '',
                      imageUrl: r.image ?? '',
                      recipe: r,
                    );
                  },
                ),
                const SizedBox(height: 20),
              ],

              if (productItems.isNotEmpty) ...[
                const Text(
                  'Favorite Products',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xFF4A3D4D)),
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: productItems.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 items per row
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75, // Adjust the height/width ratio
                  ),
                  padding: const EdgeInsets.all(2),
                  itemBuilder: (context, index) {
                    final p = productItems[index];
                    return _FavoriteCard(
                      title: p.title ?? '',
                      imageUrl: p.image ?? '',
                      subtitle: p.price != null ? '\$${double.tryParse(p.price!)?.toStringAsFixed(2) ?? p.price}' : null,
                    );
                  },
                ),

              ],
            ],
          ),
        );
      },
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? subtitle;
  final Recipes? recipe;

  const _FavoriteCard({required this.title, required this.imageUrl, this.subtitle, this.recipe});

   String cleanHtmlText(String text) {
     final document = html_parser.parse(text);
    final cleanText = document.body?.text ?? text;
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return cleanText.replaceAll(htmlTagRegex, '').trim();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (recipe != null) {
          final recipeItem = RecipeItem(
            id: recipe!.id ?? 0,
            slug: '',
            title: recipe!.title ?? '',
            link: recipe!.link ?? '',
            date: '',
            contentHtml: '<p>${cleanHtmlText(recipe!.title ?? '')}</p>',

            featuredMediaId: 0,
            imageUrl: recipe!.image ?? '',
          );
            /*Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipeItem),
            ),
          );*/
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(  // Use Expanded instead of AspectRatio
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl, fit: BoxFit.cover,
                )
                    : Container(color: const Color(0xFFF0F1F2)),
              ),
            ),
            // --- Product Name & Price ---
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36, // fixed height to keep grid alignment consistent
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: Text(
                          cleanHtmlText(title),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A3D4D),
                            height: 1.2, // line spacing
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),
                  if (subtitle != null)
                    Center(
                      child: Text(
                        subtitle!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7B8B57),
                        ),
                      ),
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
