import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:share_plus/share_plus.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import '../modal/rating_model.dart';
import '../repositories/product_repository.dart';
import '../repositories/rating_repository.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;




class TrendingRecipeDetailsScreen extends StatelessWidget {
  final String title;
  final String description;
  final double rating;
  final String imageUrl;
  final int? recipeId;
  final String excerpt;
  final String link;

  const TrendingRecipeDetailsScreen({
    super.key,
    required this.title,
    required this.description,
    required this.rating,
    required this.imageUrl,
    this.recipeId,
    required this.excerpt,
    required this.link,
  });



  String? _extractProductSlug(String url) {
    print('LINK TAPPED: $url');

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

 /* bool _isProductLink(String url) {
    return url.contains('/product/') &&
        (url.contains('sutterbuttesoliveoil.com') ||
            url.contains('staging.sutterbuttesoliveoil.com'));
  }*/
  bool _isProductLink(String url) {
    // Check for absolute URLs with domain
    bool isAbsolute = url.contains('/product/') &&
        (url.contains('sutterbuttesoliveoil.com') ||
            url.contains('staging.sutterbuttesoliveoil.com'));

    // Check for relative paths starting with /product/
    bool isRelative = url.startsWith('/product/');

    return isAbsolute || isRelative;
  }

  String _stripHtmlTags(String htmlString) {
    final RegExp exp = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '').trim();
  }



  Future<void> _printRecipe(BuildContext context) async {
    final unescape = HtmlUnescape();
    print("print PDF called");
    print("Preparing to print recipe: ${title}");

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final pdf = pw.Document();

      pw.ImageProvider? imageProvider;
      try {
        final response = await http.get(Uri.parse(imageUrl))
            .timeout(const Duration(seconds: 5));
        if (response.statusCode == 200) {
          imageProvider = pw.MemoryImage(response.bodyBytes);
        }
      } catch (e) {
        print('Error loading image: $e');
      }

      final unescape = HtmlUnescape();
      final cleanTitle = unescape.convert(title);
      final cleanDescription = unescape.convert(description);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  cleanTitle,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
                pw.SizedBox(height: 16),
                if (imageProvider != null)
                  pw.Image(imageProvider!, width: 300, height: 200),
                pw.SizedBox(height: 16),
                pw.Expanded(
                  child: pw.Text(
                    _stripHtmlTags(cleanDescription.isNotEmpty ? cleanDescription : 'No description available'),
                    style: const pw.TextStyle(fontSize: 12),
                    textAlign: pw.TextAlign.left,
                  ),
                ),
              ],
            );
          },
        ),
      );

      await Printing.layoutPdf(
        name: '$title.pdf',
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );

      // Dismiss loader when PDF interface opens
      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      print('Print error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to print: $e')),
        );
      }
    }
  }

  Future<void> _shareRecipe(BuildContext context) async {
    try {
      final unescape = HtmlUnescape();
      final cleanTitle = unescape.convert(title);
      final cleanDescription = unescape.convert(description);

      String shareText = cleanTitle + "\n\n";
      String descriptionText = _stripHtmlTags(cleanDescription.isNotEmpty ? cleanDescription : 'No description available');
      shareText += descriptionText;



      // ADD THIS PART (same as recipe detail screen)
      if (link != null && link.isNotEmpty) {
        shareText += "\n\n${link}";
      }
      await Share.share(shareText);

    } catch (e) {
      print('Share error: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to share: $e')),
        );
      }
    }
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
           /* Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),*/
            // --- Image ---
            Stack(
              children: [
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
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _printRecipe(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.print,
                        size: 20,
                        color: Color(0xFF4A3D4D),
                      ),
                    ),
                  ),
                ),

                Positioned(
                  top: 8,
                  right: 56,
                  child: GestureDetector(
                    onTap: () => _shareRecipe(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.share,
                        size: 20,
                        color: Color(0xFF4A3D4D),
                      ),
                    ),
                  ),
                ),
              ],
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
