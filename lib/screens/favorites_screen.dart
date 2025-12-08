import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import 'package:sutterbuttes_recipe/screens/recipedetailscreen.dart';
import '../modal/product_model.dart';
import '../modal/recipe_model.dart';
import '../repositories/favourites_repository.dart';
import '../modal/favourites_model.dart';
import 'package:html/parser.dart' as html_parser;

import '../repositories/product_repository.dart';
import '../utils/auth_helper.dart';


class FavoritesScreen extends StatelessWidget {
  final GlobalKey<HomeHeaderAndContentState>? favoritesKey;
  const FavoritesScreen({super.key,this .favoritesKey});


  String cleanHtmlText(String text) {

    final document = html_parser.parse(text);
    final cleanText = document.body?.text ?? text;
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return cleanText.replaceAll(htmlTagRegex, '').trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Shop , Cook & Savor Artisan Foods',
          style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              letterSpacing: 0.5,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic),
        ),
      ),
      body: _HomeHeaderAndContent(key: favoritesKey),
    );
  }
}

class _HomeHeaderAndContent extends StatefulWidget {
  const _HomeHeaderAndContent({super.key});

  @override
  State<_HomeHeaderAndContent> createState() => HomeHeaderAndContentState();
}

class HomeHeaderAndContentState extends State<_HomeHeaderAndContent> {
  int _selectedChip = 0;
  Future<FavouritesModel>? _favouritesFuture;
  @override
  void initState() {
    super.initState();
    _favouritesFuture = FavouritesRepository().getFavourites();
  }
  void refreshFavourites() {
    setState(() {
      _favouritesFuture = FavouritesRepository().getFavourites();
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (ModalRoute.of(context)?.isCurrent == true) {
      refreshFavourites();
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF7B8B57);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _favouritesFuture = FavouritesRepository().getFavourites();
          });
          await _favouritesFuture;
        },



    child:  FutureBuilder<FavouritesModel>(
      future: _favouritesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        /*if (snapshot.hasError) {
          return Center(child: Text('Failed to load favourites'));
        }*/

        if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please try again',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {});
                    },
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
        final favourites = snapshot.data;
        final recipeItems = favourites?.favorites?.recipes ?? <Recipes>[];
        final productItems = favourites?.favorites?.products ?? <Products>[];

        return  SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      product: p,
                    );
                  },
                ),

              ],
            ],
          ),
        );
      },
    )
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String? subtitle;
  final Recipes? recipe;
  final Products? product;

  const _FavoriteCard({required this.title, required this.imageUrl, this.subtitle, this.recipe, this.product});

  String cleanHtmlText(String text) {

    final unescape = HtmlUnescape();
    final decodedText = unescape.convert(text);
    final document = html_parser.parse(decodedText);
    final cleanText = document.body?.text ?? decodedText;
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return cleanText.replaceAll(htmlTagRegex, '').trim();

  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()  async {
        /*if (recipe != null) {
          final recipeItem = RecipeItem(
            id: recipe!.id ?? 0,
            slug: '',
            title: recipe!.title ?? '',
            link: recipe!.link ?? '',
            date: '',
            contentHtml: recipe!.description ?? '<p>${cleanHtmlText(recipe!.title ?? '')}</p>',
            featuredMediaId: 0,
            imageUrl: recipe!.image ?? '',
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetailScreen(recipe: recipeItem),
            ),
          );
        }*/
        if (recipe != null) {
          // Show loader
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );

          final recipeItem = RecipeItem(
            id: recipe!.id ?? 0,
            slug: '',
            title: recipe!.title ?? '',
            link: recipe!.link ?? '',
            date: '',
            contentHtml: recipe!.description ?? '<p>${cleanHtmlText(recipe!.title ?? '')}</p>',
            featuredMediaId: 0,
            imageUrl: recipe!.image ?? '',
          );

          if (context.mounted) {
            Navigator.pop(context); // Close loader
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipeItem),
              ),
            ).then((_) {
              // Refresh favorites list when returning from detail screen
              if (context.mounted) {
                final state = context.findAncestorStateOfType<HomeHeaderAndContentState>();
                if (state != null) {
                  state.refreshFavourites();
                }
              }
            });
          }
        }



        else if (product != null)   {
          final productId = product!.id ?? 0;

          // Show loader
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ),
          );


          // Small delay to ensure loader is visible
          await Future.delayed(const Duration(milliseconds: 500));

          final productDetail = await ProductRepository().getProductDetail(productId);

          if (context.mounted) {
            Navigator.pop(context); // Close loader
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailScreen(product: productDetail),
              ),
            ).then((_) {
              // Refresh favorites list when returning from detail screen
              if (context.mounted) {
                final state = context.findAncestorStateOfType<HomeHeaderAndContentState>();
                if (state != null) {
                  state.refreshFavourites();
                }
              }
            });
          }
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
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: imageUrl.isNotEmpty
                          ? Image.network(imageUrl, fit: BoxFit.cover)
                          : Container(color: const Color(0xFFF0F1F2)),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _FavouriteButton(
                        type: recipe != null ? 'recipe' : 'product',
                        id: recipe?.id ?? product?.id ?? 0,
                        onToggle: () {
                          // Refresh favorites list after toggle
                          if (context.findAncestorStateOfType<HomeHeaderAndContentState>() != null) {
                            context.findAncestorStateOfType<HomeHeaderAndContentState>()!.refreshFavourites();
                          }
                        },
                      ),
                    ),
                  ],
                ),
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
class _FavouriteButton extends StatefulWidget {
  final String type;
  final int id;
  final VoidCallback? onToggle;
  const _FavouriteButton({
    required this.type,
    required this.id,
    this.onToggle,
  });

  @override
  State<_FavouriteButton> createState() => _FavouriteButtonState();
}

class _FavouriteButtonState extends State<_FavouriteButton> {
  bool _isFavourite = true; // Start as true since items in favorites screen are already favorited
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Items in favorites screen are already favorited
    _isFavourite = true;
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
      } else {
        // Call the callback to refresh favorites list
        if (widget.onToggle != null) {
          widget.onToggle!();
        }
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
