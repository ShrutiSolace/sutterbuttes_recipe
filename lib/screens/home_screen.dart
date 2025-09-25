import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/repositories/favourites_repository.dart';
import 'package:sutterbuttes_recipe/screens/recipedetailscreen.dart';
import 'package:sutterbuttes_recipe/screens/recipes_screen.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_category_provider.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_list_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'state/cart_provider.dart';
import 'cart_screen.dart';

import '../modal/recipe_model.dart';
import '../repositories/recipe_list_repository.dart';
import '../modal/trending_recipes_model.dart';

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
          style: TextStyle(
            color: Colors.white, 
            fontSize: 18, 
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: const _HomeHeaderAndContent(),
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

  Future<void> _toggle() async {
    if (_isLoading) return;
    setState(() {
      _isLoading = true;
    });
    try {
      // optimistic update
      final next = !_isFavourite;
      setState(() {
        _isFavourite = next;
      });
      final repo = FavouritesRepository();
      final success = await repo.toggleFavourite(type: widget.type, id: widget.id);
      if (!success) {
        // revert if server rejects
        setState(() {
          _isFavourite = !next;
        });
      }
    } catch (e) {
      // revert on error
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

class _HomeHeaderAndContent extends StatefulWidget {
  const _HomeHeaderAndContent();

  @override
  State<_HomeHeaderAndContent> createState() => _HomeHeaderAndContentState();
}

class _HomeHeaderAndContentState extends State<_HomeHeaderAndContent> {
  int _selectedChip = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final recipeProvider = context.read<RecipeProvider>();
      final categoryProvider = context.read<RecipeCategoryProvider>();


      await recipeProvider.fetchRecipes();
      await categoryProvider.fetchCategories();
    });
  }


  @override
  Widget build(BuildContext context) {


    const Color brandGreen = Color(0xFF7B8B57);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              // Centered logo
              Center(
                child: Image.asset(
                  'assets/images/homescreen logo.png',
                  height: 130,
                  fit: BoxFit.contain,
                ),
              ),
              
              // Navigation icons positioned to the right

              Positioned(
                top: 0,
                right: 0,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () async {
                        context.read<CartProvider>().loadCart();
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                          Positioned(
                            top: -6,
                            right: -10,
                            child: Consumer<CartProvider>(
                              builder: (_, cart, __) {
                                final count = cart.itemCount;
                                if (count <= 0) return const SizedBox.shrink();
                                return Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFD4B25C),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Text('$count', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold)),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 19),

                    const Icon(Icons.notifications_none, color: Colors.black87),

                    const SizedBox(width: 19),
                   // Icon(Icons.person_outline, color: Colors.black87),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _SearchBar(hint:'Search recipes, ingredients,or products',
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
            },
          ),

          const SizedBox(height: 16),

          _ChipsRow(
            selectedIndex: _selectedChip,
            onSelected: (int i) => setState(() => _selectedChip = i),
            selectedColor: brandGreen,
          ),
                     const SizedBox(height: 16),
           // Featured Recipes Section
          FeaturedRecipesSection(),

           const SizedBox(height: 24),

           // Recipe Categories Section
           _RecipeCategoriesSection(),

           const SizedBox(height: 24),
           // Trending This Week Section
           _TrendingThisWeekSection(),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const _SearchBar({required this.hint, this.controller, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, size: 20),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.15)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black.withOpacity(0.15)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF7B8B57)),
          ),
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


class FeaturedRecipesSection extends StatelessWidget {
  const FeaturedRecipesSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<RecipeProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }

        if (provider.recipes.isEmpty) {
          return const Center(child: Text("No recipes available"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section Title ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Recipes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3D4D),
                  ),
                ),
                Text(
                  'See All',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7B8B57),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- Grid of Recipes ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // join parent scroll
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,      // 🔹 2 per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75, // adjust height vs width
              ),
              padding: const EdgeInsets.all(8),
              itemCount: provider.recipes.length,
              itemBuilder: (context, index) {
                final recipe = provider.recipes[index];
                return FeaturedRecipeGridCard(recipe: recipe);
              },
            ),
          ],
        );
      },
    );
  }
}

class FeaturedRecipeGridCard extends StatelessWidget {
  final RecipeItem recipe;

  const FeaturedRecipeGridCard({Key? key, required this.recipe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetailScreen(recipe: recipe),
          ),
        );
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // === Recipe Image ===
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: (recipe.imageUrl != null && recipe.imageUrl.isNotEmpty)
                          ? Image.network(recipe.imageUrl, fit: BoxFit.contain)
                          : Image.asset("assets/images/homescreen logo.png", fit: BoxFit.contain),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _FavouriteButton(type: 'recipe', id: recipe.id),
                    ),
                  ],
                ),
              ),
            ),

            // === Title ===
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                recipe.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3D4D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _RecipeCategoriesSection extends StatelessWidget {
  const _RecipeCategoriesSection();

  @override
  Widget build(BuildContext context) {

    return Consumer<RecipeCategoryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        }
        final items = provider.categories;
        if (items.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recipe Categories',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A3D4D),
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final c = items[index];
                return _CategoryCard(
                  name: c.name,
                  recipeCount: c.count,
                  imageUrl: c.image,
                );
              },
            ),
          ],
        );
      },
    );

  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final int recipeCount;
  final String imageUrl;

  const _CategoryCard({
    required this.name,
    required this.recipeCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to category recipes
        // Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryRecipesScreen(category: name)));
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.contain,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Category Info
              Positioned(
                bottom: 12,
                left: 12,
                right: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '$recipeCount recipes',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TrendingThisWeekSection extends StatelessWidget {
  const _TrendingThisWeekSection();

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
              'Trending This Week',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF4A3D4D),
              ),
            ),
            GestureDetector(
              onTap: () {
                // Navigate to all trending recipes
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
        FutureBuilder<TrendingRecipesModel>(
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
              return const SizedBox.shrink();
            }
            return SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
                itemCount: items.length,
            itemBuilder: (context, index) {
                  final r = items[index];
              return _TrendingRecipeCard(
                    title: r.title ?? '',
                    description: r.excerpt ?? '',
                    rating: (r.rating != null && r.rating!.isNotEmpty)
                        ? double.tryParse(r.rating!) ?? 0.0
                        : 0.0,
                    imageUrl: r.image ?? '',
              );
            },
          ),
            );
          },
        ),
      ],
    );
  }
}

class _TrendingRecipeCard extends StatelessWidget {
  final String title;
  final String description;
  final double rating;
  final String imageUrl;

  const _TrendingRecipeCard({
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      margin: const EdgeInsets.only(right: 16),
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
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
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
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF4A3D4D),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                
                // Recipe Description
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
                const SizedBox(height: 12),
                
                // Rating
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 16,
                    ),
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
        ],
      ),
    );
  }
}
