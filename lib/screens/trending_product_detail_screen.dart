import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/repositories/cart_repository.dart';
import 'package:sutterbuttes_recipe/screens/home_screen.dart';
import 'package:sutterbuttes_recipe/screens/state/cart_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../modal/trending_product_model.dart';
import 'all_trending_products_screen.dart';
import 'cart_screen.dart';
import 'package:html_unescape/html_unescape.dart';
class TrendingProductDetailScreen extends StatefulWidget {
  final TrendingProduct product;

  const TrendingProductDetailScreen({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<TrendingProductDetailScreen> createState() => _TrendingProductDetailScreenState();
}

class _TrendingProductDetailScreenState extends State<TrendingProductDetailScreen> {
  int _quantity = 1;

  Future<void> _launchProductUrl(BuildContext context) async {
    if (widget.product.permalink != null && widget.product.permalink!.isNotEmpty) {
      final uri = Uri.parse(widget.product.permalink!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not open product link')),
        );
      }
    }
  }

  String removeHtmlTags(String htmlText) {
    final unescape = HtmlUnescape();
    final unescaped = unescape.convert(htmlText); // decode &amp;, &nbsp;, etc.
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return unescaped.replaceAll(exp, '').trim(); // remove tags & clean spaces
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
          'Product Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Container(
              height: 300,
              width: double.infinity,
              child: (widget.product.image != null && widget.product.image!.isNotEmpty)
                  ? Image.network(
                widget.product.image!,
                fit: BoxFit.contain
                ,
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

            // Product Details
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.product.name ?? 'Product Name',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Price Section
                  // Combined Price and Quantity Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100, // Light grey background
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price Section (Left)
                        Row(
                          children: [
                            Text(
                              widget.product.price != null
                                  ? "\$${double.tryParse(widget.product.price!)?.toStringAsFixed(2) ?? widget.product.price}"
                                  : '',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7B8B57),
                              ),
                            ),
                            if (widget.product.regularPrice != null &&
                                widget.product.regularPrice != widget.product.price)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  "\$${double.tryParse(widget.product.regularPrice!)?.toStringAsFixed(2) ?? widget.product.regularPrice}",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ),
                          ],
                        ),

                        // Quantity Selector (Right)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                         /* decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(8),
                          ),*/
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Minus button
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF7B8B57),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.remove, color: Colors.white, size: 20),
                                  padding: EdgeInsets.zero,
                                  onPressed: () {
                                    if (_quantity > 0) setState(() => _quantity--);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text(
                                  '$_quantity',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              // Plus button
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xFF7B8B57),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.add, color: Colors.white, size: 20),
                                  padding: EdgeInsets.zero,
                                  onPressed: () => setState(() => _quantity++),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Product Description
                  if (widget.product.description != null && widget.product.description!.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Description',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A3D4D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          removeHtmlTags(widget.product.description ?? ''),
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            color: Colors.black87,
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),

                  // View Product Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _quantity > 0 ? () async {
                        try {
                          // Show loading
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                              child: CircularProgressIndicator(),
                            ),
                          );

                          // Add to cart with selected quantity
                          final cart = await CartRepository().addToCart(productId: widget.product.id!, quantity: _quantity);

                          // Hide loading
                          Navigator.pop(context);

                          // Show success dialog with both buttons styled the same
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              backgroundColor: Color(0xFF4A3D4D), // Dark background
                              title: Text(
                                'Success!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                '${widget.product.name} added to cart successfully!',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              actions: [
                                // Both buttons side by side with same styling
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          // Navigate to all trending products screen
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => AllTrendingProductsScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF7B8B57), // Same green as Add to Cart button
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(

                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'Continue Shopping',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12), // Space between buttons
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () async {
                                          Navigator.pop(context);

                                          // Just navigate to cart - it will load fresh data
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => CartScreen()),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF7B8B57), // Same green as Add to Cart button
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        child: Text(
                                          'View Cart',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );

                        } catch (e) {
                          Navigator.pop(context); // Hide loading if shown
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to add to cart: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      } : null,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: _quantity > 0 ? Color(0xFF7B8B57) : Colors.grey,// ✅ Light green background
                        foregroundColor: Colors.white,      // ✅ White text & icon
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.shopping_cart, size: 20),
                          SizedBox(width: 8),
                          Text(
                            ' Add to Cart',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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