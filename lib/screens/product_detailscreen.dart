import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import '../modal/product_model.dart';
import 'package:flutter_html/flutter_html.dart';
import '../repositories/cart_repository.dart';
import 'package:provider/provider.dart';
import '../repositories/favourites_repository.dart';
import '../utils/auth_helper.dart';
import 'cart_screen.dart';
import 'state/cart_provider.dart';
import 'package:html/parser.dart' as html_parser;


class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}


class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAdding = false;
  // added for the variations
  String? _selectedOptions;
  int? _selectedVariationId;

  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndExecutePendingAction();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }





  String cleanHtmlText(String text) {
    // Parse the HTML and extract text content (this handles all HTML entities)
    final document = html_parser.parse(text);
    final cleanText = document.body?.text ?? text;

    // Remove any remaining HTML tags
    final RegExp htmlTagRegex = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return cleanText.replaceAll(htmlTagRegex, '').trim();
  }

  List<String> extractImagesFromDescription(String htmlDescription) {
    final List<String> imageUrls = [];

    try {
      final document = html_parser.parse(htmlDescription);
      final imgTags = document.querySelectorAll('img');

      for (var img in imgTags) {
        final src = img.attributes['src'];
        if (src != null && src.isNotEmpty) {
          imageUrls.add(src);
        }
      }
    } catch (e) {
      // If error, return empty list
    }

    return imageUrls;
  }

  List<String> getAllProductImages() {
    final List<String> allImages = [];

    // Add images from product.images list
    if (widget.product.images.isNotEmpty) {
      for (var image in widget.product.images) {
        if (image.src.isNotEmpty) {
          allImages.add(image.src);
        }
      }

    }
    // Add images extracted from product.description
    final descriptionImages = extractImagesFromDescription(widget.product.description);
    allImages.addAll(descriptionImages);

    // Remove duplicates
    return allImages.toSet().toList();
  }



  //  Check and execute pending add to cart action
  Future<void> _checkAndExecutePendingAction() async {
    final pendingAction = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (pendingAction != null &&
        pendingAction['action'] == 'add_to_cart' &&
        pendingAction['productId'] == widget.product.id) {

      if (mounted) {
        setState(() {
          _quantity = pendingAction['quantity'] ?? 1;
          _selectedVariationId = pendingAction['variationId'] as int?;
          // Restore variation option if variation was selected
          if (_selectedVariationId != null && widget.product.variations.isNotEmpty) {
            final variationIdValue = _selectedVariationId!;
            final index = widget.product.variations.indexOf(variationIdValue);
            if (index >= 0 && index < widget.product.options.length) {
              _selectedOptions = widget.product.options[index];
            }
          }
        });

        // Execute add to cart automatically
        await _executeAddToCart();
      }
    }
  }


 /* Future<void> _executeAddToCart() async {
    FocusScope.of(context).unfocus();
    setState(() { _isAdding = true; });

    if (widget.product.variation == true && _selectedVariationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option before adding to cart'))
      );
      setState(() { _isAdding = false; });
      return;
    }

    try {
      final repo = CartRepository();
      final result = await repo.addToCart(
          productId: widget.product.id,
          quantity: _quantity,
          variationId: _selectedVariationId
      );
      final msg = result.message ?? 'Added to cart';

      if (mounted) setState(() { _isAdding = false; });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg))
      );
      try {
        await context.read<CartProvider>().loadCart();
      } catch (_) {}
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add to cart: $e'))
      );
    } finally {
      if (mounted) setState(() { _isAdding = false; });
    }
  }
*/

  Future<void> _executeAddToCart() async {
    FocusScope.of(context).unfocus();
    setState(() { _isAdding = true; });

    if (widget.product.variation == true && _selectedVariationId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option before adding to cart'))
      );
      setState(() { _isAdding = false; });
      return;
    }

    try {
      final repo = CartRepository();
      final result = await repo.addToCart(
          productId: widget.product.id,
          quantity: _quantity,
          variationId: _selectedVariationId
      );

      // Refresh cart
      try {
        await context.read<CartProvider>().loadCart();
      } catch (_) {}

      if (mounted) setState(() { _isAdding = false; });

      // Show success dialog with both buttons (no loading dialog - button already shows loader)
      if (context.mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              'Success!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text(
              widget.product.variation == true && _selectedOptions != null
                  ? '${widget.product.name} (${_selectedOptions}) added to cart successfully!'
                  : '${widget.product.name} added to cart successfully!',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            actions: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pop(context); // Go back to previous screen (shop/products)
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B8B57),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Continue Shopping',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const CartScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7B8B57),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
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
      }
    } catch (e) {
      if (mounted) setState(() { _isAdding = false; });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to add to cart: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    const Color brandGreen = Color(0xFF7B8B57);

    Widget _buildPageIndicator(int index, int total) {
      return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          if (!_pageController.hasClients) {
            return Container(
              width: 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[300],
              ),
            );
          }

          final currentPage = _pageController.page?.round() ?? 0;
          return Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentPage == index
                  ? const Color(0xFF7B8B57)
                  : Colors.grey[300],
            ),
          );
        },
      );
    }


    Widget _getProductImageSlider() {
      final allImages = getAllProductImages();

      if (allImages.isEmpty) {
        // Fallback if no images
        return AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              "assets/images/homescreen logo.png",
              fit: BoxFit.contain,
            ),
          ),
        );
      }

      return Column(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: PageView.builder(
              controller: _pageController,
              itemCount: allImages.length,
              itemBuilder: (context, index) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: Colors.white,
                    child: Image.network(
                      allImages[index],
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/homescreen logo.png",
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          // Page indicator dots
          if (allImages.length > 1)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  allImages.length,
                      (index) => _buildPageIndicator(index, allImages.length),
                ),
              ),
            ),
        ],
      );
    }



    // ADD DEBUG PRINTS HERE (between line 39 and 41):
    print("=== PRODUCT VARIATION DEBUG ===");
    print("Product ID: ${widget.product.id}");
    print("Product Name: ${widget.product.name}");
    print("Variation field: ${widget.product.variation}");
    print("Variation type: ${widget.product.variation.runtimeType}");
    print("Options: ${widget.product.options}");
    print("Options length: ${widget.product.options.length}");
    print("Variations: ${widget.product.variations}");
    print("Variations length: ${widget.product.variations.length}");
    print("Should show dropdown: ${widget.product.variation == true && widget.product.options.isNotEmpty}");
    print("Selected Option: $_selectedOptions");
    print("Selected Variation ID: $_selectedVariationId");
    print("================================");



    return WillPopScope(
        onWillPop: () async {
      if (_isAdding) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait, add to cart is processing'),
            duration: Duration(seconds: 2),
          ),
        );
        return false; // Prevent back navigation
      }
      return true; // Allow back navigation
    },

    child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context); // returns to the previous screen, i.e. the search list
            },
          ),




        title: Text(
          unescape.convert(widget.product.name),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _FavouriteButton(type: 'product', id: widget.product.id),
          ),
        ]
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Product Image
            /*AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: widget.product.images.isNotEmpty
                    ? Image.network(
                  widget.product.images.first.src,
                  fit: BoxFit.cover,
                )
                    : Image.asset(
                  "assets/images/homescreen logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),*/
            // Product Image Slider
            _getProductImageSlider(),

            const SizedBox(height: 16),
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3D4D),
              ),
            ),
            const SizedBox(height: 16),

            // Price + Quantity + Add Button UI (static, below In Stock)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE8E6EA)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Variation Options Dropdown (moved to top)
                  if (widget.product.variation == true && widget.product.options.isNotEmpty) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Choose an Option",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF4A3D4D),
                          ),
                        ),
                        const SizedBox(height: 8),

                        SizedBox(
                          width: double.infinity,
                         child:  DropdownButtonFormField<String>(
                          value: _selectedOptions,
                           isExpanded: true,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE8E6EA)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Color(0xFFE8E6EA)),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          hint: const Text("Select an option"),
                          items: widget.product.options.map((String option) {
                            return DropdownMenuItem<String>(
                              value: option,
                              child: Text(
                                option,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedOptions = newValue;

                              if (newValue != null) {
                                final index = widget.product.options.indexOf(newValue);
                                if (index >= 0 && index < widget.product.variations.length) {
                                  _selectedVariationId = widget.product.variations[index];
                                }
                              } else {
                                _selectedVariationId = null;
                              }
                            });
                          },
                        ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16), // Add spacing after dropdown
                  ],


                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price (reuse priceHtml if present for styling/parsing)
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: (widget.product.priceHtml.isNotEmpty)
                              ? Html(
                                  data: """<div>${widget.product.priceHtml}</div>""",
                                  style: {
                                    "div": Style(
                                      fontSize: FontSize(20),
                                      fontWeight: FontWeight.bold,
                                      color: brandGreen,
                                    ),
                                    "span": Style(
                                      fontSize: FontSize(20),
                                      fontWeight: FontWeight.bold,
                                      color: brandGreen,
                                    ),
                                    "bdi": Style(
                                      fontSize: FontSize(20),
                                      fontWeight: FontWeight.bold,
                                      color: brandGreen,
                                    ),
                                  },
                                )
                              : Text(

                            "\$${double.tryParse(widget.product.price)?.toStringAsFixed(2) ?? widget.product.price}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: brandGreen,
                                  ),
                                ),
                        ),
                      ),
                      Row(
                        children: [

                       /*   GestureDetector(
                            onTap: () {
                              if (_quantity > 1) {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.remove, size: 18, color: Colors.black54),
                            ),
                          ),*/
                          //  Disabled decrement button when adding to cart
                          GestureDetector(
                            onTap: _isAdding || widget.product.stockStatus != 'instock'
                                ? null // 🔒 disable tap when adding to cart
                                : () {
                               if (_quantity > 0) {
                                setState(() {
                                  _quantity--;
                                });
                              }
                            },
                            child: Opacity(
                              //disable if outof stock
                              opacity: _isAdding  || widget.product.stockStatus != 'instock'? 0.5 : 1, // 🔆 dim while disabled
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                  color: Color(0xFF7B8B57),
                                ),
                                child: const Icon(Icons.remove, size: 18, color: Colors.white),
                              ),
                            ),
                          ),





                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "$_quantity",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                        /*  GestureDetector(
                            onTap: () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            child: Container(
                              width: 36,
                              height: 36,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: const Color(0xFFE0E0E0)),
                                color: Colors.white,
                              ),
                              child: const Icon(Icons.add, size: 18, color: Colors.black54),
                            ),
                          ),*/
                          //  Disabled increment button when adding to cart
                          GestureDetector(
                            onTap: _isAdding || widget.product.stockStatus != 'instock'
                                ? null // 🔒 disable tap when adding to cart
                                : () {
                              setState(() {
                                _quantity++;
                              });
                            },
                            child: Opacity(
                              opacity: _isAdding || widget.product.stockStatus != 'instock' ? 0.5 : 1,
                              child: Container(
                                width: 36,
                                height: 36,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFE0E0E0)),
                                  color: Color(0xFF7B8B57),
                                ),
                                child: const Icon(Icons.add, size: 18, color: Colors.white),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isAdding || widget.product.stockStatus != 'instock' || _quantity == 0 || (widget.product.variation == true && _selectedVariationId == null)


                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              // ADD: Check login before adding to cart
                              final isLoggedIn = await AuthHelper.checkAuthAndPromptLogin(
                                context,
                                productId: widget.product.id,
                                quantity: _quantity,
                                variationId: _selectedVariationId,
                              );

                              if (!isLoggedIn) {
                                return;
                              }

                              await _executeAddToCart();

                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _quantity > 0 ? brandGreen : Colors.grey,
                        disabledBackgroundColor:  Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: _isAdding
                          ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Icon(Icons.shopping_cart, color: Colors.white),
                      label: const Text("Add to Cart", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Product Name
          /*  Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3D4D),
              ),
            ),*/

            const SizedBox(height: 8),


            // Price
          /*  if (widget.product.priceHtml.isNotEmpty)
              Html(
                data: """<div>${widget.product.priceHtml}</div>""", // wrapped inside a div
                style: {
                  "div": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                    margin: Margins.zero,
                  ),
                  "span": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                    margin: Margins.zero,
                  ),
                  "bdi": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                    margin: Margins.zero,
                  ),
                },
              )
            else
              Text(
                "\$${widget.product.price}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: brandGreen,
                ),
              ),*/


            const SizedBox(height: 8),

            // Stock Status
            Row(
              children: [
                Icon(
                  widget.product.stockStatus == 'instock'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: widget.product.stockStatus == 'instock'
                      ? Colors.green
                      : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  widget.product.stockStatus == 'instock'
                      ? "In Stock"
                      : "Out of Stock",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: widget.product.stockStatus == 'instock'
                        ? Colors.green[700]
                        : Colors.red[700],
                  ),
                ),
              ],
            ),


            // Variation Options Dropdown
              /* if (widget.product.variation == true && widget.product.options.isNotEmpty) ...[
              const SizedBox(height: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                         const Text(
                             "Choose Option",
                               style: TextStyle(
                               fontSize: 16,
                                fontWeight: FontWeight.w600,
                                 color: Color(0xFF4A3D4D),
                               ),
                                ),
    const SizedBox(height: 8),
    DropdownButtonFormField<String>(
    value: _selectedOptions,
    decoration: InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE8E6EA)),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Color(0xFFE8E6EA)),
    ),
    filled: true,
    fillColor: Colors.white,
    ),
    hint: const Text("Select an option..."),
    items: widget.product.options.map((String option) {
    return DropdownMenuItem<String>(
    value: option,
    child: Text(option),
    );
    }).toList(),
    onChanged: (String? newValue) {
    setState(() {
    _selectedOptions = newValue;
    // Find the corresponding variation ID
    if (newValue != null) {
    final index = widget.product.options.indexOf(newValue);
    if (index >= 0 && index < widget.product.variations.length) {
    _selectedVariationId = widget.product.variations[index];
    }
    } else {
    _selectedVariationId = null;
    }
    });
    },
    ),
    ],
    ),
    ],
*/
    const SizedBox(height: 16),

            // Short Description
            if (widget.product.shortDescription.isNotEmpty)
              Html(
                data:  cleanHtmlText(widget.product.shortDescription),
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    color: Colors.black87,
                  ),
                },
              ),

            const SizedBox(height: 16),

            // Full Description
            if (widget.product.description.isNotEmpty) ...[
              const Text(
                "Description",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A3D4D)),
              ),
              const SizedBox(height: 8),
              Html(
                data: cleanHtmlText(widget.product.description),
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    color: Colors.black87,
                  ),
                },
              ),
            ],

            const SizedBox(height: 24),

            // Add to Cart Button
          /*  SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.product.stockStatus == 'instock'
                    ? () {
                  // TODO: Add cart functionality
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text(
                  "Add to Cart 111",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),*/
          ],
        ),
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

    final isLoggedIn = await AuthHelper.checkAuthAndPromptLogin(
      context,
      attemptedAction: 'mark_favorite',
        favoriteType: widget.type,  // ✅ ADD THIS
        favoriteId: widget.id,
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