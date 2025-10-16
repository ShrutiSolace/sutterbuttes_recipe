import 'package:flutter/material.dart';
import '../modal/product_model.dart';
import 'package:flutter_html/flutter_html.dart';
import '../repositories/cart_repository.dart';
import 'package:provider/provider.dart';
import 'state/cart_provider.dart';



class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _quantity = 1;
  bool _isAdding = false;

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF7B8B57);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ White back arrow
        title: Text(
          widget.product.name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis, // ✅ truncate long names
        ),
        centerTitle: true, // optional: centers the title nicely
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Product Image
            AspectRatio(
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
                                  "\$${widget.product.price}",
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
                          GestureDetector(
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
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "$_quantity",
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          GestureDetector(
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
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isAdding || widget.product.stockStatus != 'instock'
                          ? null
                          : () async {
                              FocusScope.of(context).unfocus();
                              setState(() { _isAdding = true; });
                              try {
                                final repo = CartRepository();
                                final result = await repo.addToCart(productId: widget.product.id, quantity: _quantity);
                                final msg = result.message ?? 'Added to cart';
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)
                                )

                                );
                                try {
                                  await context.read<CartProvider>().loadCart();
                                } catch (_) {}
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add to cart: $e')));
                              } finally {
                                if (mounted) setState(() { _isAdding = false; });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
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
            Text(
              widget.product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3D4D),
              ),
            ),

            const SizedBox(height: 8),

            // Price
            // Price
            if (widget.product.priceHtml.isNotEmpty)
              Html(
                data: """<div>${widget.product.priceHtml}</div>""", // wrapped inside a div
                style: {
                  "div": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                  ),
                  "span": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
                  ),
                  "bdi": Style(
                    fontSize: FontSize(18),
                    fontWeight: FontWeight.bold,
                    color: brandGreen,
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
              ),


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

            const SizedBox(height: 16),

            // Short Description
            if (widget.product.shortDescription.isNotEmpty)
              Html(
                data: widget.product.shortDescription,
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
                data: widget.product.description,
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
    );
  }
}
