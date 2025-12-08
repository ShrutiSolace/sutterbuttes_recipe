import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/repositories/favourites_repository.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_category_provider.dart';
import '../modal/category_recipe_model.dart';
import '../utils/auth_helper.dart';
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

    final document = html_parser.parse(text);
    final cleanText = document.body?.text ?? text;
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
            String message = 'Please try again';
            if (provider.errorMessage.contains('503')) {
              message = 'Please try again';
            } else if (provider.errorMessage.contains('507')) {
              message = 'Please try again';
            } else if (provider.errorMessage.contains('timeout') || provider.errorMessage.contains('network')) {
              message = 'No internet connection. Please check your network.';
            }

            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => provider.fetchRecipesByCategory(widget.categoryId),
                      child: const Text('Retry'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B8B57),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
            );
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
                              title: cleanHtmlText(recipe.title),
                              imageUrl: recipe.image,
                              subtitle: recipe.description ?? '',
                              recipeId: recipe.id,
                              link: recipe.link,
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
                            /*Expanded(
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
                            ),*/
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                child: Stack(
                                  children: [
                                    Positioned.fill(
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
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: _RecipeFavouriteButton(recipeId: recipe.id),
                                    ),
                                  ],
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

class _RecipeFavouriteButton extends StatefulWidget {
  final int recipeId;
  const _RecipeFavouriteButton({required this.recipeId});

  @override
  State<_RecipeFavouriteButton> createState() => _RecipeFavouriteButtonState();
}

class _RecipeFavouriteButtonState extends State<_RecipeFavouriteButton> {
  bool _isFavourite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final repo = FavouritesRepository();
      final favorites = await repo.getFavourites();

      final recipeIds = favorites.favorites?.recipes?.map((r) => r.id).toList() ?? [];
      setState(() {
        _isFavourite = recipeIds.contains(widget.recipeId);
      });
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggle() async {
    final isLoggedIn = await AuthHelper.checkAuthAndPromptLogin(
      context,
      attemptedAction: 'mark_favorite',
      favoriteType: 'recipe',
      favoriteId: widget.recipeId,
    );

    if (!isLoggedIn) {
      return;
    }

    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final next = !_isFavourite;
      setState(() {
        _isFavourite = next;
      });
      final repo = FavouritesRepository();
      final success = await repo.toggleFavourite(type: 'recipe', id: widget.recipeId);
      if (!success) {
        setState(() {
          _isFavourite = !next;
        });
      }
    } catch (e) {
      setState(() {
        _isFavourite = !_isFavourite;
      });
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(
        SnackBar(content: Text('Failed to update favourite')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggle,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 18,
          width: 18,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Icon(
          _isFavourite ? Icons.favorite : Icons.favorite_border,
          size: 18,
          color: _isFavourite ? Colors.red : const Color(0xFF4A3D4D),
        ),
      ),
    );
  }
}
