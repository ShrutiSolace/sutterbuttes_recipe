import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import '../repositories/product_repository.dart';
import '../modal/product_model.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

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

class _HomeHeaderAndContent extends StatefulWidget {
  const _HomeHeaderAndContent();

  @override
  State<_HomeHeaderAndContent> createState() => _HomeHeaderAndContentState();
}

class _HomeHeaderAndContentState extends State<_HomeHeaderAndContent> {
  int _selectedChip = 0;

  // Product-related variables
  List<Product> _products = [];
  bool _isLoadingProducts = false;
  String? _productError;
  final ProductRepository _productRepository = ProductRepository();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  Future<void> _refreshProducts() async {
    await _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _productError = null;
    });

    try {
      final products = await _productRepository.getProducts();
      setState(() {
        _products = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        _productError = e.toString();
        _isLoadingProducts = false;
      });
    }
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
                  children: const <Widget>[
                    Icon(Icons.shopping_cart_outlined, color: Colors.black87),
                    SizedBox(width: 19),
                    Icon(Icons.notifications_none, color: Colors.black87),
                    SizedBox(width: 19),
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
          const SizedBox(height: 16),
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

    if (_productError != null) {
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

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,      // 2 per row (same as recipes)
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.75, // adjust height vs width
      ),
      padding: const EdgeInsets.all(8),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final product = data[index];
        return _buildProductCard(product);
      },
    );
  }

  List<Product> _applyFilters(List<Product> products) {
    Iterable<Product> result = products;

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
                    fit: BoxFit.contain,
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
                    // Heart Icon
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border,
                          size: 18,
                          color: Color(0xFF4A3D4D),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Product Information
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Price
                  Text(
                    '\$${product.price}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF7B8B57),
                    ),
                  ),
                  const SizedBox(height: 4),

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
        controller: controller,
        onChanged: onChanged,
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
    final List<String> labels = <String>['All Products', 'Out of Stock', 'In Stock', 'On Sale'];
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