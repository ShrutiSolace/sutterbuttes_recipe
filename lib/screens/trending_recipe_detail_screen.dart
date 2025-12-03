import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import '../modal/rating_model.dart';
import '../repositories/product_repository.dart';
import '../repositories/rating_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class TrendingRecipeDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final double rating;
  final String imageUrl;
  final int? recipeId;
  final String excerpt;

  const TrendingRecipeDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    this.recipeId,
    required this.excerpt,
  });



  String? _extractProductSlug(String url) {
    print('🔗 LINK TAPPED: $url');

    try {
      final uri = Uri.parse(url);
      final pathSegments = uri.pathSegments;


      if (pathSegments.contains('product') && pathSegments.length > 1) {
        final productIndex = pathSegments.indexOf('product');
        if (productIndex < pathSegments.length - 1) {

          String slug = pathSegments[productIndex + 1];

          slug = slug.replaceAll('/', '');
          return slug;
        }
      }


      final productMatch = RegExp(r'/product/([^/]+)').firstMatch(url);
      if (productMatch != null) {
        return productMatch.group(1);
      }

      return null;
    } catch (e) {
      print('Error extracting product slug: $e');
      return null;
    }
  }

  bool _isProductLink(String url) {
    return url.contains('/product/') &&
        (url.contains('sutterbuttesoliveoil.com') ||
            url.contains('staging.sutterbuttesoliveoil.com'));
  }









  @override
  Widget build(BuildContext context) {
    final unescape = HtmlUnescape();
    final title = unescape.convert(this.title);
    final description = unescape.convert(this.description);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        //title: Text(title),

        backgroundColor: const Color(0xFF4A3D4D),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Image ---
            Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // --- Title + Rating ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4A3D4D),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const SizedBox(height: 8),
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
                      }

                      return Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 4),
                          Text(
                            ratingText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      );
                    },
                  )

                      : Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                 // const SizedBox(height: 16),

                 /* // Shop Ingredients Button
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.shopping_cart,
                      color: Colors.white,
                      size: 16,
                    ),
                    label: const Text(
                      'Shop Ingredients',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B8B57),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
*/
                  const SizedBox(height: 10),
                  // --- Description ---
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Html(
                      data: description.isNotEmpty
                          ? description
                          : "No description available",
                      onLinkTap: (url, attributes, element) async {
                        print('+++++Link Slug+++++: $url');
                        print('Attributes: $attributes');
                        if (url == null) return;

                        if (_isProductLink(url)) {
                          print("Detected product link.");
                          final slug = _extractProductSlug(url);

                          if (slug != null) {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => const Center(child: CircularProgressIndicator()),
                            );

                            try {

                              print("Fetching product with slug: $slug");
                              final productRepo = ProductRepository();
                              final product = await productRepo.getProductBySlug(slug);

                              if (context.mounted) {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ProductDetailScreen(product: product),
                                  ),
                                );
                              }
                            } catch (e) {

                              if (context.mounted) {
                                Navigator.pop(context);


                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to load product: $e'),
                                    backgroundColor: Colors.red,
                                  ),
                                );


                                final uri = Uri.parse(url);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                                }
                              }
                            }
                          } else {

                            final uri = Uri.parse(url);
                            if (await canLaunchUrl(uri)) {
                              await launchUrl(uri, mode: LaunchMode.externalApplication);
                            }
                          }
                        } else {

                          final uri = Uri.parse(url);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        }
                      },

                      style: {
                        "img": Style(display: Display.none),
                        "h1": Style(
                          fontSize: FontSize(20),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          margin: Margins.only(top: 24, bottom: 16),
                        ),
                        "h2": Style(
                          fontSize: FontSize(18),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          margin: Margins.only(top: 20, bottom: 12),
                        ),
                        "h3": Style(
                          fontSize: FontSize(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          margin: Margins.only(top: 16, bottom: 12),
                        ),
                        "h4": Style(
                          fontSize: FontSize(16),
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                          margin: Margins.only(top: 16, bottom: 12),
                        ),
                        "p": Style(
                          fontSize: FontSize(16),
                          color: Colors.grey[800],
                          margin: Margins.only(top: 8, bottom: 12),
                          padding: HtmlPaddings.zero,
                        ),
                        "ul": Style(
                          padding: HtmlPaddings.only(left: 20),
                          margin: Margins.only(top: 8, bottom: 16),
                        ),
                        "ol": Style(
                          padding: HtmlPaddings.only(left: 20),
                          margin: Margins.only(top: 8, bottom: 16),
                        ),
                        "li": Style(
                          padding: HtmlPaddings.only(left: 8, bottom: 8),
                          margin: Margins.zero,
                          fontSize: FontSize(16),
                          color: Colors.grey[800],
                          listStyleType: ListStyleType.disc,
                          display: Display.listItem,
                        ),
                        "body": Style(
                          padding: HtmlPaddings.all(0),
                          margin: Margins.zero,
                          fontSize: FontSize(16),
                          color: Colors.grey[800],
                        ),
                      },
                    ),
                  ),

                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
