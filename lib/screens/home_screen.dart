import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sutterbuttes_recipe/repositories/favourites_repository.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import 'package:sutterbuttes_recipe/screens/recipedetailscreen.dart';
import 'package:sutterbuttes_recipe/screens/recipes_screen.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_category_provider.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_list_provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/trending_product_detail_screen.dart';
import 'package:sutterbuttes_recipe/screens/trending_recipe_detail_screen.dart';
import 'package:sutterbuttes_recipe/screens/trending_screen.dart';
import '../modal/product_model.dart';
import '../modal/rating_model.dart';
import '../modal/search_model.dart';
import '../repositories/notifications_repository.dart';
import '../repositories/product_repository.dart';
import '../repositories/rating_repository.dart';
import '../services/notification_service.dart';
import '../utils/auth_helper.dart';
import 'all_trending_products_screen.dart';
import 'bottom_navigation.dart';
import 'category_recipe_screen.dart';
import 'state/cart_provider.dart';
import 'cart_screen.dart';
import '../modal/recipe_model.dart';
import '../repositories/recipe_list_repository.dart';
import '../modal/trending_recipes_model.dart';
import 'package:html_unescape/html_unescape.dart';
import 'dart:math' as math;
import 'state/product_provider.dart';
import '../modal/trending_product_model.dart';
import 'dart:async';
import 'state/search_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'notifications_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: false,
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
  bool _isFavourite = false ;
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

      if (widget.type == 'recipe') {
        final recipeIds = favorites.favorites?.recipes?.map((r) => r.id).toList() ?? [];
        setState(() {
          _isFavourite = recipeIds.contains(widget.id);
        });
      } else if (widget.type == 'product') {
        final productIds = favorites.favorites?.products?.map((p) => p.id).toList() ?? [];
        setState(() {
          _isFavourite = productIds.contains(widget.id);
        });
      }
    } catch (e) {
      // If there's an error, keep _isFavourite as false
      print('Error checking favorite status: $e');
    }
  }


/*
  Future<void> _checkAndExecutePendingAction() async {
    final route = ModalRoute.of(context);
    if (route == null) return;

    final pendingAction = route.settings.arguments as Map<String, dynamic>?;

    if (pendingAction != null &&
        pendingAction['action'] == 'mark_favorite' &&
        pendingAction['favoriteType'] == widget.type &&
        pendingAction['favoriteId'] == widget.id) {

      await _executeToggle();
    }
  }


  Future<void> _executeToggle() async {
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
  }*/


  Future<void> _toggle() async {

    final isLoggedIn = await AuthHelper.checkAuthAndPromptLogin(
        context,
        attemptedAction: 'mark_favorite', favoriteType: widget.type, favoriteId: widget.id
    );

    if (!isLoggedIn) {
      return; // User cancelled login or not logged in
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
  final unescape = HtmlUnescape();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

 // List<RecipeItem> _allRecipes = [];
  //List<RecipeItem> _filteredRecipes = [];
  Timer? _debounceTimer;
  bool _isSearching = false;
  int _unreadNotificationCount = 0;
  bool _hasViewedNotifications = false;


/*  Future<void> _loadAllRecipesForSearch() async {
    try {
      final recipeRepository = RecipeListRepository();
      final recipes = await recipeRepository.getRecipes(page: 1, perPage: 100); // Load more recipes for search
      setState(() {
        _allRecipes = recipes;
        _filteredRecipes = recipes;
      });
    } catch (e) {
      print('Error loading recipes for search: $e');
    }
  }*/

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh notification count when screen is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUnreadNotificationCount(); // Always reload when screen becomes visible
      context.read<CartProvider>().loadCart();
    });
  }





  void _onSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {

      if (query.trim().isNotEmpty && query.trim().length < 3) {
        if (_isSearching) {
          setState(() => _isSearching = false);
        }
        context.read<SearchProvider>().clearSearch();
        return;
      }

      if (query.trim().isNotEmpty && query.trim().length >= 3) {
        if (!_isSearching) {
          setState(() => _isSearching = true);
        }
        context.read<SearchProvider>().searchItems(query.trim());
      } else {
        if (_isSearching) {
          setState(() => _isSearching = false);
        }
        context.read<SearchProvider>().clearSearch();
      }
    });
  }


  Future<void> _loadUnreadNotificationCount() async {

    try {
      final notificationsRepository = DeviceRegistrationRepository();
      final response = await notificationsRepository.getNotifications();
      final notifications = response.notifications ?? [];

      print("+++++++");
      print('=== NOTIFICATION COUNT DEBUG ===');
      print('API Count field: ${response.count}');
      print('Total notifications: ${response.notifications?.length ?? 0}');


      final prefs = await SharedPreferences.getInstance();
      final savedReadIds = prefs.getStringList('readNotificationIds') ?? [];
      final readIdsSet = savedReadIds.map((id) => int.tryParse(id)).whereType<int>().toSet();

      int count = 0;
      for (var notification in notifications) {
        if (notification.id != null && readIdsSet.contains(notification.id)) {
          continue;
        }
        bool isRead = false;
        if (notification.markedAsRead == true) {
          isRead = true;
        }

        final status = notification.status?.toLowerCase();
        if (status == 'read') {
          isRead = true;
        }


        if (!isRead) {
          count++;
        }
      }

      print('Calculated: $count (Local read: ${readIdsSet.length}), API count: ${response.count}');





      if (mounted) {
        setState(() {
          _unreadNotificationCount = count;
        });
      }
    } catch (e) {
      print('Error loading notification count: $e');
      if (mounted) {
        setState(() {
          _unreadNotificationCount = 0;
        });
      }
    }
  }


  @override
  void dispose() {
    _debounceTimer?.cancel();
    _searchController.dispose();
    // Clear notification callback
    NotificationService.onNotificationReceived = null;
    super.dispose();
  }



  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final recipeProvider = context.read<RecipeProvider>();
      final categoryProvider = context.read<RecipeCategoryProvider>();
      final productProvider = context.read<ProductProvider>();


      await recipeProvider.fetchRecipes();

      await Future.delayed(const Duration(milliseconds: 500));

      await categoryProvider.fetchCategories();

      await Future.delayed(const Duration(milliseconds: 300));

      await productProvider.fetchTrendingProducts();
      _loadUnreadNotificationCount();

      context.read<CartProvider>().loadCart();

      NotificationService.onNotificationReceived = _loadUnreadNotificationCount;
    //  _loadAllRecipesForSearch();
    });
  }
  Future<void> _refreshHomeScreen() async {
    final recipeProvider = context.read<RecipeProvider>();
    final categoryProvider = context.read<RecipeCategoryProvider>();
    final productProvider = context.read<ProductProvider>();



    await recipeProvider.fetchRecipes();
    await categoryProvider.fetchCategories();
    await productProvider.fetchTrendingProducts();
   // await _loadUnreadNotificationCount();
  }

  @override
  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF7B8B57);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return WillPopScope(
        onWillPop: () async {
      // If user is in search mode, exit search instead of going back
      if (_isSearching) {
        setState(() {
          _isSearching = false;
          _searchController.clear();
        });
        context.read<SearchProvider>().clearSearch();
        return false; // Prevent default back navigation
      }

      return true;
    },
    child: _isSearching
    ? Column(
    children: [
    _SearchBar(
    hint: 'Search recipes, ingredients, or products',
    controller: _searchController,
    onChanged: _onSearchChanged,
    ),
    const SizedBox(height: 16),
    Expanded(
    child: _SearchResultsSection(),
    ),
    ],
    )
        : RefreshIndicator(
    onRefresh: _refreshHomeScreen,
    child: SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: <Widget>[
              // Centered logo
              Center(
                child: Image.asset(
                  'assets/images/artisan foods logo.jpg',
                  height: 130,
                  fit: BoxFit.cover,
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

                        final isAuthenticated = await AuthHelper.checkAuthAndPromptLogin(
                          context,
                          attemptedAction: 'cart',
                        );
                        if (!isAuthenticated) {
                          return; // User cancelled login, don't navigate
                        }



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
                                    color: Color(0xFF7B8B57),
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

                    GestureDetector(
                      onTap: ()  async {


                        final isAuthenticated = await AuthHelper.checkAuthAndPromptLogin(
                          context,
                          attemptedAction: 'view notifications',
                        );
                        if (!isAuthenticated) {
                          return; // User cancelled login, don't navigate
                        }






                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NotificationsScreen()),
                        )..then((_) {

                          _hasViewedNotifications = false;
                          _loadUnreadNotificationCount();
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          const Icon(Icons.notifications_none, color: Colors.black87),
                          if (_unreadNotificationCount > 0)
                            Positioned(
                              top: -6,
                              right: -6,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF7B8B57),
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$_unreadNotificationCount',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),


                    const SizedBox(width: 19),
                   // Icon(Icons.person_outline, color: Colors.black87),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _SearchBar(
            hint: 'Search recipes, ingredients, or products',
            controller: _searchController,
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 10),

        /*  _ChipsRow(
            selectedIndex: _selectedChip,
            onSelected: (int i) => setState(() => _selectedChip = i),
            selectedColor: brandGreen,
          ),*/
                     const SizedBox(height: 16),
           // Featured Recipes Section
          FeaturedRecipesSection(),

           const SizedBox(height: 24),
          TrendingProductSection(),

            const SizedBox(height: 24),
           // Recipe Categories Section
           _RecipeCategoriesSection(),

           const SizedBox(height: 24),
           // Trending This Week Section
           _TrendingThisWeekSection(),
        ],
      ),
    ),
    )
    );
  }
}
class _SearchBar extends StatefulWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  const _SearchBar({required this.hint, this.controller, this.onChanged});

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  String _currentText = '';

  @override
  void initState() {
    super.initState();
    _currentText = widget.controller?.text ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      child: TextField(
        controller: widget.controller,
        onChanged: (value) {
          if (mounted) {
            setState(() {
              _currentText = value;
            });
          }
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
        },
        decoration: InputDecoration(
          hintText: widget.hint,
          filled: true,
          fillColor: Colors.white,
          prefixIcon: const Icon(Icons.search, size: 20),
          suffixIcon: _currentText.isNotEmpty
              ? IconButton(
            icon: const Icon(Icons.clear, size: 20),
            onPressed: () {
              if (!mounted) return;

              widget.controller?.clear();
              setState(() {
                _currentText = '';
              });
              if (widget.onChanged != null) {
                widget.onChanged!('');
              }
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

    final List<String> labels = <String>[''];
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
/*
        if (provider.errorMessage != null) {
          return Center(child: Text(provider.errorMessage!));
        }*/

        if (provider.errorMessage != null) {
          String message = 'Please try again.';
          if (provider.errorMessage!.contains('503')) {
            message = '';
          } else if (provider.errorMessage!.contains('507')) {
            message = '';
          } else if (provider.errorMessage!.contains('timeout') || provider.errorMessage!.contains('network')) {
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
                    onPressed: () => provider.fetchRecipes(),
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
          return const Center(child: Text("No recipes available"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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


                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigationScreen(
                          initialIndex: 1, // Recipes tab
                          customScreen: const RecipesScreen(),
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7B8B57),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),


            // --- Grid of Recipes ---//
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              padding: const EdgeInsets.all(2),
             // itemCount: provider.recipes.length,
              itemCount: math.min(4, provider.recipes.length),
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


class TrendingProductSection extends StatelessWidget {
  const TrendingProductSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.isTrendingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

       /* if (provider.trendingErrorMessage != null) {
          return Center(child: Text(provider.trendingErrorMessage!));
        }*/


        if (provider.trendingErrorMessage != null) {
          String message = 'Please try again.';
          if (provider.trendingErrorMessage!.contains('503')) {
            message = '';
          } else if (provider.trendingErrorMessage!.contains('507')) {
            message = '';
          } else if (provider.trendingErrorMessage!.contains('timeout') || provider.trendingErrorMessage!.contains('network')) {
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
                    onPressed: () => provider.fetchTrendingProducts(),
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
/*
        final products = provider.trendingProducts?.products ?? [];

        if (products.isEmpty) {
          return const Center(child: Text("No trending products available"));
        }
 */
        if (provider.trendingProducts == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final products = provider.trendingProducts!.products ?? [];

        if (products.isEmpty) {
          return const Center(child: Text("No trending products available"));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Section Title ---
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Trending Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3D4D),
                  ),
                ),

                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavigationScreen(
                          initialIndex: 2, // Shop tab
                          customScreen: AllTrendingProductsScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'See All',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7B8B57),
                    ),
                  ),
                ),



              ],
            ),
            const SizedBox(height: 16),

            // --- Grid of Trending Products ---
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.75,
              ),
              padding: const EdgeInsets.all(2),
              itemCount: math.min(4, products.length),
              itemBuilder: (context, index) {
                final product = products[index]; // <-- now works!
                return TrendingProductCard(product: product);
              },
            ),
          ],
        );
      },
    );
  }
}

class TrendingProductCard extends StatelessWidget {
  final TrendingProduct product;

  const TrendingProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TrendingProductDetailScreen(product: product),
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
            // --- Product Image ---
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    // The image fills the stack
                    Positioned.fill(
                      child: (product.image != null && product.image!.isNotEmpty)
                          ? Image.network(
                        product.image!,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/homescreen_logo.png",
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                          );
                        },
                      )
                          : Image.asset(
                        "assets/images/homescreen_logo.png",
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),

                    // Favourite button on top-right
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _FavouriteButton(
                        type: 'product',
                        id: product.id ?? 0, // handle nullable safely
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
                          product.name ?? '',
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
                  Center(
                    child: Text(
                      product.price != null
                          ? "\$${double.tryParse(product.price!)?.toStringAsFixed(2) ?? product.price}"
                          : '',
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













class _RecipeCategoriesSection extends StatelessWidget {
  const _RecipeCategoriesSection();

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();

    return Consumer<RecipeCategoryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
       /* if (provider.errorMessage.isNotEmpty) {
          return Center(child: Text(provider.errorMessage));
        }*/


        if (provider.errorMessage.isNotEmpty) {
          String message = 'Please try again.';
          if (provider.errorMessage.contains('503')) {
            message = '';
          } else if (provider.errorMessage.contains('507')) {
            message = '';
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
                    onPressed: () => provider.fetchCategories(),
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
                  id: c.id,
                  name: unescape.convert(c.name),
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
  final int id;
  final String name;
  final int recipeCount;
  final String imageUrl;

  const _CategoryCard({
    required this.id,
    required this.name,
    required this.recipeCount,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to category recipes
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BottomNavigationScreen(
              initialIndex: 1, // Recipes tab
              customScreen: CategoryRecipesScreen(categoryId: id),
            ),
          ),
        );
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
                    fit: BoxFit.cover,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BottomNavigationScreen(
                      initialIndex: 1, // Recipes tab
                      customScreen: const AllTrendingRecipesScreen(),
                    ),
                  ),
                );
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
        future: Future.delayed(const Duration(milliseconds: 100))
        .then((_) => RecipeListRepository().getTrendingRecipes()),

          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            /*if (snapshot.hasError) {
              return Center(child: Text('Failed to load trending recipes'));
            }*/



            if (snapshot.hasError) {
              String errorMsg = snapshot.error.toString();
              String message = 'Please try again.';
              if (errorMsg.contains('503')) {
                message = '';
              } else if (errorMsg.contains('507')) {
                message = '';
              } else if (errorMsg.contains('timeout') || errorMsg.contains('network')) {
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
                        onPressed: () {
                          (context as Element).markNeedsBuild();
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
                    recipeId: r.id,
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
  final int? recipeId;

  const _TrendingRecipeCard({
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    this.recipeId,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => TrendingRecipeDetailsScreen(
                title: title,
                description: description,
                rating: rating,
                imageUrl: imageUrl,
                recipeId: recipeId,



              ),
            ),
          );
        },

        child:  Container(
      width: 200,
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
          // Recipe Image
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: AspectRatio(
              aspectRatio: 16 / 9, // Adjust as needed for your design
              child: Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover, // ensures image fills the space without distortion
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
                // Rating - Dynamic from API if recipeId is available
                recipeId != null
                    ? FutureBuilder<RatingsModel>(
                  future: RatingsRepository().getRecipeRatings(recipeId!),
                  builder: (context, snapshot) {
                    String ratingText = rating.toString();
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      ratingText = 'Loading...';
                    } else if (snapshot.hasData) {
                      ratingText = snapshot.data!.average.toStringAsFixed(1);
                    } else if (snapshot.hasError) {
                      // If error, show the static rating as fallback
                      print('Error loading rating: ${snapshot.error}');
                      ratingText = rating.toString();
                    }

                    return Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          ratingText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    );
                  },
                )
                    : Row(
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
    )
    );
  }
}
class _SearchResultsSection extends StatelessWidget {
  const _SearchResultsSection();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, searchProvider, _) {
        if (searchProvider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (searchProvider.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              'Error: ${searchProvider.errorMessage}',
              style: const TextStyle(fontSize: 16, color: Colors.red),
            ),
          );
        }

        if (searchProvider.searchResults.isEmpty) {
          return const Center(
            child: Text(
              'No results found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Search Results for "${searchProvider.currentQuery}" (${searchProvider.searchResults.length})',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4A3D4D),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: searchProvider.searchResults.length,
                itemBuilder: (context, index) {
                  final item = searchProvider.searchResults[index];
                  return _SearchResultCard(searchItem: item);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchItem searchItem;

  const _SearchResultCard({required this.searchItem});

  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Container(
            width: 60,
            height: 60,
            child: searchItem.image.isNotEmpty
                ? Image.network(
              searchItem.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/homescreen logo.png",
                  fit: BoxFit.cover,
                );
              },
            )
                : Image.asset(
              "assets/images/homescreen logo.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          unescape.convert(searchItem.title),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF4A3D4D),
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              searchItem.type.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: searchItem.type == 'recipe'
                    ? const Color(0xFF7B8B57)
                    : const Color(0xFF4A3D4D),
              ),
            ),
            if (searchItem is SearchProductItem)
              Text(
                '\$${double.tryParse((searchItem as SearchProductItem).price)?.toStringAsFixed(2) ?? (searchItem as SearchProductItem).price}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B8B57),
                ),
              ),
            if (searchItem is SearchRecipeItem)
              Text(
                (searchItem as SearchRecipeItem).excerpt,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Color(0xFF4A3D4D),
        ),
        /*onTap: () {
          // Handle navigation based on item type
          if (searchItem.type == 'recipe') {
            // Navigate to recipe detail
            print('Navigate to recipe: ${searchItem.id}');
          } else if (searchItem.type == 'product') {
            // Navigate to product detail
            print('Navigate to product: ${searchItem.id}');
          }
        },*/

        onTap: () async {
          if (searchItem.type == 'recipe') {


            final recipeItem = RecipeItem(
              id: searchItem.id,
              slug: '',
              title: searchItem.title,
              link: searchItem.link,
              date: '',
              contentHtml: (searchItem as SearchRecipeItem).description ?? '',
              featuredMediaId: 0,
              imageUrl: searchItem.image,
            );


            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipeDetailScreen(recipe: recipeItem),
              ),
            );
          }
          else if (searchItem.type == 'product') {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const Center(child: CircularProgressIndicator()),
            );

            try {
              final productRepo = ProductRepository();
              final product = await productRepo.getProductDetail(searchItem.id);

              Navigator.pop(context); // closes the dialog
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
              );
            } catch (e) {
              Navigator.pop(context); // closes the dialog
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to load product details: $e')),
              );
            }
          }
        },

      ),
    );
  }
}