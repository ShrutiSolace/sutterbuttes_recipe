import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_category_provider.dart';
import '../modal/category_recipe_model.dart';
import 'category_recipe_detail_screen.dart';
import 'package:html/parser.dart' as html_parser;

class CategoryRecipesScreen extends StatefulWidget {
  final int categoryId;

  const CategoryRecipesScreen({required this.categoryId, super.key});

  @override
  State<CategoryRecipesScreen> createState() => _CategoryRecipesScreenState();
}

class _CategoryRecipesScreenState extends State<CategoryRecipesScreen> {
  final ScrollController _scrollController = ScrollController();

  String cleanHtmlText(String text) {
    // Parse the HTML and extract text content (this handles all HTML entities)
    final document = html_parser.parse(text);
    final cleanText = document.body?.text ?? text;

    // Remove any remaining HTML tags
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return cleanText.replaceAll(htmlTagRegex, '').trim();
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider =
      Provider.of<RecipeCategoryProvider>(context, listen: false);
      provider.fetchRecipesByCategory(widget.categoryId);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        final provider = Provider.of<RecipeCategoryProvider>(context, listen: false);
        if (provider.hasMore && !provider.isLoadingMore) {
          provider.loadMoreRecipesByCategory(widget.categoryId);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Recipes",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Consumer<RecipeCategoryProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          }
          if (provider.recipes.isEmpty) {
            return const Center(child: Text("No recipes found"));
          }

          final items = provider.recipes;

          return Column(
            children: [
              Expanded(
                child: GridView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final recipe = items[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryRecipeDetailScreen(
                              title: recipe.title,
                              imageUrl: recipe.image,
                              subtitle: recipe.description ?? '',
                              recipeId: recipe.id,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: recipe.image.isNotEmpty
                                    ? Image.network(
                                  recipe.image,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.restaurant),
                                    );
                                  },
                                )
                                    : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.restaurant),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 40,
                                alignment: Alignment.center,
                                child: Text(
                                  cleanHtmlText(recipe.title),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: Color(0xFF4A3D4D),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              if (provider.isLoadingMore)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(),
                        SizedBox(height: 8),
                        Text('Loading more recipes...'),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
