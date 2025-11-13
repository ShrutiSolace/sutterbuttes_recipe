import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:sutterbuttes_recipe/screens/state/about_us_provider.dart';
import '../modal/about_us_model.dart';
import 'home_screen.dart';
import 'shop_screen.dart';



class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AboutContentProvider>(context, listen: false).fetchAboutContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Consumer<AboutContentProvider>(
        builder: (context, aboutProvider, child) {
          if (aboutProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A3D4D)),
              ),
            );
          }

          if (aboutProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load content',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    aboutProvider.error!,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => aboutProvider.fetchAboutContent(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A3D4D),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final content = aboutProvider.aboutContent;

          if (content == null) {
            return const Center(child: Text('No content available.'));
          }

          // Convert AboutContentModel to Map for dynamic rendering
          final Map<String, dynamic> contentMap = {
            //'Title': content.title,
            '': content.content,
           /* 'Excerpt': content.excerpt,*/
           /* 'Slug': content.slug,
            'Status': content.status,*/
            /*'Type': content.type,
            'Date': content.date,
            'Modified': content.modified,*/
            'Contact Us:':
            '<b>Name:</b> ${content.author.name ?? 'N/A'}<br>'
                '<b>Email:</b> ${content.author.email ?? 'N/A'}<br>'
                '<b>Website:</b> <a href="${content.author.url ?? '#'}">${content.author.url ?? 'N/A'}</a>',
          };

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  child: Image.asset(
                    'assets/images/artisan foods logo.jpg', // replace with your logo path
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),










                // Section-wise dynamic rendering
                ...contentMap.entries.map((entry) => _buildSectionContainer(entry.key, entry.value)),

                const SizedBox(height: 24),

                // Static section: Experience the Difference
                _buildExperienceSection(context),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionContainer(String title, dynamic value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          value != null
              ? Center(

            child: Html(data: value.toString(),
              style: {
                "img": Style(
                  width: Width(300), // Set image width
                  height: Height(150), // Set image height
                  margin: Margins.symmetric( vertical: 10),
                  alignment: Alignment.center, // Center the image
                ),
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                ),
              },
            ), // <-- Render HTML content
          )
              : const Text('N/A', style: TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
  Widget _buildExperienceSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Experience the Difference',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3D4D),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Taste the tradition, quality, and passion in every drop of Sutter Buttes olive oil.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.black54, height: 1.4),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50, // Same height for both
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ShopScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B8B57),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: const Text(
                        'Shop Our Products',
                        style: TextStyle(
                          fontSize: 15, // Same font size for both
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50, // Same height for both
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B8B57),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Center(
                      child: const Text(
                        'Explore Recipes',
                        style: TextStyle(
                          fontSize: 15, // Same font size for both
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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
}

