import 'package:flutter/material.dart';
import '../modal/product_model.dart';
import 'package:flutter_html/flutter_html.dart';



class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    const Color brandGreen = Color(0xFF7B8B57);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        title: Text(
          product.name,
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
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
                child: product.images.isNotEmpty
                    ? Image.network(
                  product.images.first.src,
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
                          child: (product.priceHtml.isNotEmpty)
                              ? Html(
                                  data: """<div>${product.priceHtml}</div>""",
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
                                  "\$${product.price}",
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
                          // adding
                          // Disabled minus button (UI only)
                          Container(
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
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              "1",
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                          ),
                          // Disabled plus button (UI only)
                          Container(
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
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: null, // UI only (non-functional)
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandGreen,
                        disabledBackgroundColor: brandGreen,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(Icons.shopping_cart, color: Colors.white),
                      label: const Text(
                        "Add to Cart",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Name
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A3D4D),
              ),
            ),

            const SizedBox(height: 8),

            // Price
            // Price
            if (product.priceHtml.isNotEmpty)
              Html(
                data: """<div>${product.priceHtml}</div>""", // wrapped inside a div
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
                "\$${product.price}",
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
                  product.stockStatus == 'instock'
                      ? Icons.check_circle
                      : Icons.cancel,
                  color: product.stockStatus == 'instock'
                      ? Colors.green
                      : Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  product.stockStatus == 'instock'
                      ? "In Stock"
                      : "Out of Stock",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: product.stockStatus == 'instock'
                        ? Colors.green[700]
                        : Colors.red[700],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Short Description
            if (product.shortDescription.isNotEmpty)
              Html(
                data: product.shortDescription,
                style: {
                  "body": Style(
                    fontSize: FontSize(14),
                    color: Colors.black87,
                  ),
                },
              ),

            const SizedBox(height: 16),

            // Full Description
            if (product.description.isNotEmpty) ...[
              const Text(
                "Description",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4A3D4D)),
              ),
              const SizedBox(height: 8),
              Html(
                data: product.description,
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
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: product.stockStatus == 'instock'
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
                  "Add to Cart",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
