import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/home_screen.dart';
import '../repositories/recipe_list_repository.dart';
import '../modal/recipe_model.dart';
import '../repositories/favourites_repository.dart';
import '../repositories/search_repository.dart';
import 'recipedetailscreen.dart';

import '../modal/search_model.dart';

class RecipesScreen extends StatefulWidget {

  const RecipesScreen({super.key});

  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState extends State<RecipesScreen> {
  final RecipeListRepository _recipeRepository = RecipeListRepository();
  final SearchRepository _searchRepository = SearchRepository();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<RecipeItem> _allRecipes = [];
  List<RecipeItem> _filteredRecipes = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _perPage = 10;
  bool _hasMoreData = true;
  bool _isAllItemsLoaded = false;
  Timer? _searchDebounceTimer;

  @override
  void initState() {
    super.initState();
    _loadRecipes();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounceTimer?.cancel();
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreRecipes();
    }
  }

  Future<void> _loadRecipes() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = 1;
      _hasMoreData = true;
      _isAllItemsLoaded =  false;
    });

    try {
      final recipes = await _recipeRepository.getRecipes(page: 1, perPage: _perPage);
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
        _hasMoreData = recipes.length == _perPage;
        _isAllItemsLoaded = true;  // <-- ADD THIS LINE
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreRecipes() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newRecipes = await _recipeRepository.getRecipes(page: nextPage, perPage: _perPage);

      setState(() {
        _allRecipes.addAll(newRecipes);
        // Only update filtered recipes if not searching
        if (_searchQuery.isEmpty) {
          _filteredRecipes = _allRecipes;
        }
        // If searching, don't update _filteredRecipes here - search API handles it
        _currentPage = nextPage;
        _isLoadingMore = false;
        _hasMoreData = newRecipes.length == _perPage;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });

    // Cancel previous timer if user is still typing
    _searchDebounceTimer?.cancel();

    // If query is empty, show all loaded recipes immediately
    if (query.trim().isEmpty) {
      setState(() {
        _filteredRecipes = _allRecipes;
      });
      return;
    }


    _searchDebounceTimer = Timer(const Duration(milliseconds: 500), () async {
      if (_searchQuery.trim().isEmpty) {
        setState(() {
          _filteredRecipes = _allRecipes;
        });
        return;
      }

      try {
        final searchResult = await _searchRepository.searchItems(_searchQuery.trim());


        final List<RecipeItem> searchResults = searchResult.results.recipes.map((searchRecipe) {
          return RecipeItem(
            id: searchRecipe.id,
            slug: '',
            title: searchRecipe.title,
            link: searchRecipe.link,
            date: '',
            contentHtml: searchRecipe.excerpt,
            featuredMediaId: 0,
            imageUrl: searchRecipe.image,
          );
        }).toList();

        if (mounted) {
          setState(() {
            _filteredRecipes = searchResults;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _filteredRecipes = [];
            _error = 'Search failed: $e';
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            // Check if we can pop, if not navigate to home
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              Navigator.of(context).pushReplacementNamed('/home');
            }
          },
        ),

        title: const Text(
          'All Recipes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: 'Roboto',
          ),
        ),
      ),

      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              enabled: _isAllItemsLoaded,  // <-- ADD THIS LINE
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search recipes...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: const Icon(Icons.search, size: 20),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, size: 20),
                  onPressed: () {
                    _searchController.clear();
                    _onSearchChanged(''); // This will clear the search and show all recipes
                  },
                )
                    : null,
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
          ),

          // Recipe Count
          if (_filteredRecipes.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '${_filteredRecipes.length} recipes found',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 8),

          // Recipe List
          Expanded(
            child: _buildRecipeList(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecipeList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadRecipes,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredRecipes.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No recipes found for "$_searchQuery"'
                  : 'No recipes available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 0.75,
            ),
            itemCount: _filteredRecipes.length,
            itemBuilder: (context, index) {
              final recipe = _filteredRecipes[index];
              return _RecipeGridCard(recipe: recipe);
            },
          ),
        ),
        if (_isLoadingMore)
          Container(
            padding: const EdgeInsets.all(20),
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 12),
                  Text('Loading more recipes...'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _RecipeGridCard extends StatelessWidget {
  final RecipeItem recipe;

  const _RecipeGridCard({required this.recipe});

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
            // === Recipe Image ===
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: (recipe.imageUrl != null && recipe.imageUrl.isNotEmpty)
                          ? Image.network(
                        recipe.imageUrl,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/homescreen logo.png",
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          );
                        },
                      )
                          : Image.asset(
                        "assets/images/homescreen logo.png",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
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
              child: Center(
                child: Text(
                  recipe.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3D4D),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
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