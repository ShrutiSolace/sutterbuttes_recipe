import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import '../repositories/notifications_repository.dart';
import '../repositories/product_repository.dart';
import '../modal/product_model.dart';
import '../repositories/favourites_repository.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import '../utils/auth_helper.dart';
import 'notifications_screen.dart';
import 'state/cart_provider.dart';
import 'cart_screen.dart';
import 'dart:async';
import '../repositories/search_repository.dart';
import '../modal/search_model.dart';
import 'package:html_unescape/html_unescape.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text(
          'Shop , Cook & Savor',
          style: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: 'Roboto',
            fontStyle: FontStyle.italic,
          ),
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


  List<Product> _products = [];
  bool _isLoadingProducts = false;
  String? _productError;
  final ProductRepository _productRepository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _unreadNotificationCount = 0;
  bool _hasViewedNotifications = false;



  int _currentPage = 1;
  final int _perPage = 40;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  final ScrollController _scrollController = ScrollController();


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
        // Skip if already in local read list
        if (notification.id != null && readIdsSet.contains(notification.id)) {
          continue;
        }

        // Check if API says it's read
        bool isRead = false;

        // Check API's mark_as_read field
        if (notification.markedAsRead == true) {
          isRead = true;
        }

        // Check API's status field (only 'read' means read, not 'success')
        final status = notification.status?.toLowerCase();
        if (status == 'read') {
          isRead = true;
        }

        // Only count if NOT read
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
  void initState() {
    super.initState();
    _loadProducts();
    _loadUnreadNotificationCount();
    _loadUnreadNotificationCount();
    NotificationService.onNotificationReceived = _loadUnreadNotificationCount;  // ADD THIS


    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        _loadMoreProducts();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUnreadNotificationCount();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    NotificationService.onNotificationReceived = null;
    super.dispose();
  }

  Future<void> _refreshProducts() async {

    setState(() {
      _currentPage = 1;
      _hasMoreData = true;
      _products = [];
    });
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _productError = null;
      _currentPage = 1;
      _hasMoreData = true;
    });

    try {
      final products = await _productRepository.getProducts(
        page: _currentPage,
        perPage: _perPage,
      );
      setState(() {
        _products = products;
        _isLoadingProducts = false;
        _hasMoreData = products.length >= _perPage;
      });
    } catch (e) {
      setState(() {
        _productError = e.toString();
        _isLoadingProducts = false;
      });
    }
  }



  Future<void> _loadMoreProducts() async {
    if (_isLoadingMore || !_hasMoreData || _isLoadingProducts) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final products = await _productRepository.getProducts(
        page: nextPage,
        perPage: _perPage,
      );

      setState(() {
        _products.addAll(products);
        _currentPage = nextPage;
        _isLoadingMore = false;
        _hasMoreData = products.length >= _perPage;
      });
    } catch (e) {
      setState(() {
        _productError = e.toString();
        _isLoadingMore = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    const Color brandGreen = Color(0xFF7B8B57);
    final TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        // ✅ ADD: Check authentication first
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
                                  child: Text(
                                    '$count',
                                    style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 19),

                    GestureDetector(
                      onTap: () async {
                        // Check if user is authenticated before showing notifications
                        final isAuthenticated = await AuthHelper.checkAuthAndPromptLogin(
                          context,
                          attemptedAction: 'view notifications',
                        );
                        if (!isAuthenticated) {
                          return; // User cancelled login, don't navigate
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) =>  NotificationsScreen()),
                        )..then((_) {
                          // Always reload from API to get accurate count after marking as read
                          _hasViewedNotifications = false; // Reset flag to allow reload
                          _loadUnreadNotificationCount(); // Reload actual count from API
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
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SearchBar(
            hint: 'Search Products',
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value.trim();
              });
            },
          ),
          const SizedBox(height: 2),
          _ChipsRow(
            selectedIndex: _selectedChip,
            onSelected: (int i) {
              setState(() {
                _selectedChip = i;
              });
              // Refresh the products when switching chips
              _refreshProducts();
            },
            selectedColor: brandGreen,
          ),
          const SizedBox(height: 16),
          // Product listing section
          _buildProductListing(),
        ],
      ),
    );
  }

  Widget _buildProductListing() {
    if (_isLoadingProducts) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF7B8B57),
        ),
      );
    }

    /*if (_productError != null) {
      return Center(
        child: Column(
          children: [
            Text('Error: $_productError'),
            ElevatedButton(
              onPressed: () {
                _loadProducts(); // Retry loading
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }*/
    if (_productError != null) {
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
                onPressed: _loadProducts,
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

    if (_products.isEmpty) {
      return const Center(
        child: Text('No products available'),
      );
    }

    final List<Product> data = _applyFilters(_products);

    if (data.isEmpty) {
      return const Center(child: Text('No matching products'));
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,  // Add this line
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,      // 2 per row (same as recipes)
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
            childAspectRatio: 0.65, // adjust height vs width
          ),
          padding: const EdgeInsets.all(8),
          itemCount: data.length,
          itemBuilder: (context, index) {
            final product = data[index];
            return _buildProductCard(product);
          },
        ),
        // Add loading indicator at bottom
        if (_isLoadingMore)
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: CircularProgressIndicator(
                color: Color(0xFF7B8B57),
              ),
            ),
          ),
      ],
    );
  }




  List<Product> _applyFilters(List<Product> products) {
    Iterable<Product> result = products;

    // Filter to show only published products
    result = result.where((p) => p.status.trim().toLowerCase() == 'publish');




    // Chip filters
    switch (_selectedChip) {
      case 1: // Featured
        result = result.where((p) => p.stockStatus == 'outofstock');
        break;
      case 2: // In Stock
        result = result.where((p) => p.stockStatus == 'instock');
        break;
      case 3: // On Sale
        result = result.where((p) => p.onSale == true);
        break;
      default:
        break; // All Products
    }

    // Search filter
    if (_searchQuery.isNotEmpty) {
      final String q = _searchQuery.toLowerCase();
      result = result.where((p) {
        final name = p.name.toLowerCase();
        final sku = p.sku.toLowerCase();
        final categories = p.categories.map((c) => c.name.toLowerCase()).join(' ');
        return name.contains(q) || sku.contains(q) || categories.contains(q);
      });
    }

    return result.toList();
  }

  Widget _buildProductCard(Product product) {
    final unescape = HtmlUnescape();
    return GestureDetector(
      onTap: () {Navigator.push (
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: product),
        ),
      );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),  // Add this line

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
                      child: (product.images.isNotEmpty)
                          ? Image.network(
                        product.images.first.src,
                        fit: BoxFit.cover, // keeps full image, no cropping
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/homescreen logo.png",
                            fit: BoxFit.contain,
                          );
                        },
                      )

                          : Image.asset(
                        "assets/images/homescreen logo.png",
                        fit: BoxFit.contain,
                      ),
                    ),
                    // Heart Icon (toggle favourite)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: _ProductFavouriteButton(productId: product.id),
                    ),
                  ],
                ),
              ),
            ),

            // Product Information
            // Product Information
            Container(
              height: 100, // Fixed height for consistent alignment
              alignment: Alignment.center, // Center all content vertically
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center, // Vertically center
                crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center
                children: [
                  // Product Name
                  Text(
                    unescape.convert(product.name),
                    textAlign: TextAlign.center, // Center the text
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Text(
                    '\$${double.tryParse(product.price)?.toStringAsFixed(2) ?? product.price}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B8B57),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Stock Status
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: product.stockStatus == 'instock'
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      product.stockStatus == 'instock' ? 'In Stock' : 'Out of Stock',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 10,
                        color: product.stockStatus == 'instock'
                            ? Colors.green[700]
                            : Colors.red[700],
                        fontWeight: FontWeight.w500,
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

class _ProductFavouriteButton extends StatefulWidget {
  final int productId;
  const _ProductFavouriteButton({required this.productId});

  @override
  State<_ProductFavouriteButton> createState() => _ProductFavouriteButtonState();
}

class _ProductFavouriteButtonState extends State<_ProductFavouriteButton> {
  bool _isFavourite = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    // slight delay to ensure context is ready
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final repo = FavouritesRepository();
      final favorites = await repo.getFavourites();

      final productIds = favorites.favorites?.products?.map((p) => p.id).toList() ?? [];
      setState(() {
        _isFavourite = productIds.contains(widget.productId);
      });
    } catch (e) {
      // If there's an error, keep _isFavourite as false
      print('Error checking favorite status: $e');
    }
  }

  Future<void> _toggle() async {
    final isLoggedIn = await AuthHelper.checkAuthAndPromptLogin(
      context,
      attemptedAction: 'mark_favorite',  // ✅ ADD THIS
        favoriteId: widget.productId,
    );

    if (!isLoggedIn) {
      return; // User cancelled login or not logged in
    }





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
      final success = await repo.toggleFavourite(type: 'product', id: widget.productId);
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
            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : Icon(_isFavourite ? Icons.favorite : Icons.favorite_border,
            size: 18, color: _isFavourite ? Colors.red : const Color(0xFF4A3D4D)),
      ),
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
    final List<String> labels = <String>[];
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
