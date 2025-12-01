import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import 'package:flutter_html/flutter_html.dart';
import '../modal/rating_model.dart';  // ← ADD THIS
import '../repositories/favourites_repository.dart';
import '../repositories/rating_repository.dart';
import '../utils/auth_helper.dart';

class CategoryRecipeDetailScreen extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String subtitle;
  final int recipeId;

  const  CategoryRecipeDetailScreen ({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.subtitle,
    required this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    final cleanTitle = unescape.convert(title);
    final cleanSubtitle = unescape.convert(subtitle);
    return Scaffold(

      backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color(0xFF4A3D4D),
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          centerTitle: true,
          title: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: _FavouriteButton(type: 'recipe', id: recipeId),
            ),
          ],
        ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Recipe Image
            if (imageUrl.isNotEmpty)
              Image.network(
                imageUrl,
                height: 250,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 250,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 80),
                  );
                },
              )
            else
              Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant, size: 80),
              ),

            // Recipe Title
            // Wrap everything in one Padding widget
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Recipe Title
                  Text(
                    cleanTitle,
                    style: const TextStyle(
                      fontSize: 18,  // ← Change from 22 to 18 to match
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),  // ← Change from Colors.black87 to match
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Rating
                  FutureBuilder<RatingsModel>(
                    future: RatingsRepository().getRecipeRatings(recipeId),
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
                    onPressed: () {},
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

                  // Recipe Description (Ingredients and Directions)
                  Html(
                    data: (subtitle.isNotEmpty)
                        ? subtitle
                        : "No description available",
                    style: {
                      "img": Style(
                        display: Display.none,
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
                      "h4": Style(
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
                        padding: HtmlPaddings.only(left: 20),
                        margin: Margins.only(top: 8, bottom: 16),
                      ),
                      "ol": Style(
                        padding: HtmlPaddings.only(left: 20),
                        margin: Margins.only(top: 8, bottom: 16),
                      ),
                      "li": Style(
                        padding: HtmlPaddings.only(left: 8, bottom: 8),
                        margin: Margins.zero,
                        fontSize: FontSize(16),
                        color: Colors.grey[800],
                        listStyleType: ListStyleType.disc,
                        display: Display.listItem,
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
class _FavouriteButton extends StatefulWidget {
  final String type;
  final int id;
  const _FavouriteButton({required this.type, required this.id});

  @override
  State<_FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<_FavouriteButton> {
  bool _isFavourite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    try {
      final repo = FavouritesRepository();
      final favorites = await repo.getFavourites();

      if (widget.type == 'recipe') {
        final recipeIds = favorites.favorites?.recipes?.map((r) => r.id).toList() ?? [];
        setState(() {
          _isFavourite = recipeIds.contains(widget.id);
        });
      }
    } catch (e) {
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggle() async {
    final isLoggedIn = await AuthHelper.checkAuthAndPromptLogin(
      context,
      attemptedAction: 'mark_favorite',
      favoriteType: widget.type,
      favoriteId: widget.id,
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
      final success = await repo.toggleFavourite(type: widget.type, id: widget.id);
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
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: _isLoading
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        )
            : Icon(
          _isFavourite ? Icons.favorite : Icons.favorite_border,
          size: 20,
          color: _isFavourite ? Colors.red : const Color(0xFF4A3D4D),
        ),
      ),
    );
  }
}
