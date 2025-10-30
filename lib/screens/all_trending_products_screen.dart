import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/profile_screen.dart';
import 'package:sutterbuttes_recipe/screens/recipes_screen.dart';
import 'package:sutterbuttes_recipe/screens/trending_product_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../repositories/product_repository.dart';
import '../modal/trending_product_model.dart';
import '../repositories/favourites_repository.dart';
import 'dart:math' as math;

import 'favorites_screen.dart';

class AllTrendingProductsScreen extends StatefulWidget {
  const AllTrendingProductsScreen({super.key});

  @override
  State<AllTrendingProductsScreen> createState() => _AllTrendingProductsScreenState();
}

class _AllTrendingProductsScreenState extends State<AllTrendingProductsScreen> {
  final ProductRepository _productRepository = ProductRepository();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  List<TrendingProduct> _allProducts = [];
  List<TrendingProduct> _filteredProducts = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  String _searchQuery = '';
  int _currentPage = 1;
  final int _perPage = 10;
  bool _hasMoreData = true;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreProducts();
    }
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = 1;
      _hasMoreData = true;
    });

    try {
      final result = await _productRepository.getTrendingProducts();
      setState(() {
        _allProducts = result.products ?? [];
        _filteredProducts = result.products ?? [];
        _isLoading = false;
        _hasMoreData = (_allProducts.length >= _perPage);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      // For now, we'll simulate loading more by showing all products
      // You'll need to implement pagination in your API later
      setState(() {
        _isLoadingMore = false;
        _hasMoreData = false; // No more data for now
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
      _filteredProducts = _allProducts.where((product) {
        return (product.name ?? '').toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Trending Products',
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
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search products...',
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
          ),

          // Product Count
          if (_filteredProducts.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    '${_filteredProducts.length} products found',
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

          // Product List
          Expanded(
            child: _buildProductList(),
          ),
        ],
      ),


    );
  }

  Widget _buildProductList() {
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
              onPressed: _loadProducts,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_filteredProducts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty
                  ? 'No products found for "$_searchQuery"'
                  : 'No products available',
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
            itemCount: _filteredProducts.length,
            itemBuilder: (context, index) {
              final product = _filteredProducts[index];
              return _ProductGridCard(product: product);
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
                  Text('Loading more products...'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _ProductGridCard extends StatelessWidget {
  final TrendingProduct product;

  const _ProductGridCard({required this.product});

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
            // Product Image
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: (product.image != null && product.image!.isNotEmpty)
                          ? Image.network(
                        product.image!,
                        fit: BoxFit.contain,
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
                      child: _FavouriteButton(
                        type: 'product',
                        id: product.id ?? 0,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Name & Price
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 36, // fixed height to keep grid alignment consistent
                    child: Text(
                      product.name ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left, // or .left depending on your layout
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4A3D4D),
                        height: 1.2, // line spacing
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),
                  Text(
                    product.price != null ? "\$${product.price}" : '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF7B8B57),
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

      if (widget.type == 'product') {
        final productIds = favorites.favorites?.products?.map((p) => p.id).toList() ?? [];
        setState(() {
          _isFavourite = productIds.contains(widget.id);
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