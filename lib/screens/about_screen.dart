import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/screens/recipes_screen.dart';
import 'package:sutterbuttes_recipe/screens/shop_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section with Logo and Title
            _buildHeaderSection(),
            const SizedBox(height: 24),
            
            // Our Story Section
            _buildOurStorySection(),
            const SizedBox(height: 24),
            
            // Key Metrics Section
            _buildKeyMetricsSection(),
            const SizedBox(height: 24),
            
                         // Our Values Section
             _buildOurValuesSection(),
             const SizedBox(height: 24),
             
             // Our Process Section
             _buildOurProcessSection(),
             const SizedBox(height: 24),
             
                           // Our Location Section
              _buildOurLocationSection(),
              const SizedBox(height: 24),
              
                             // Awards & Recognition Section
               _buildAwardsSection(),
               const SizedBox(height: 24),
               
               // Experience the Difference Section
               _buildExperienceSection(context),
               const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      children: [
        // Logo
        Image.asset(
          'assets/images/Sutter Buttes Logo.png',
          height: 150,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 4),

        Text(
          '',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),

        // Underline with dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
        ),
        const SizedBox(height: 4),
        
        // Main Title
        Text(
          'About Sutter Buttes',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),


        // Subtitle
        Text(
          'Our passion, our commitment...',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildOurStorySection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Story',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Founded in 1985, Sutter Buttes Olive Oil began as a small family farm in the heart of California\'s Sutter Buttes region. What started as a passion project has grown into one of California\'s most respected producers of premium olive oils and artisanal vinegars.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Our founder, Maria Rodriguez, brought traditional Spanish olive oil making techniques to California, combining them with the unique terroir of the Sutter Buttes to create oils of exceptional quality and character. Today, we continue her legacy with the same dedication to craftsmanship and quality.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKeyMetricsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Metrics',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildMetricCard(Icons.calendar_today, '38+', 'Years of Excellence')),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard(Icons.eco, '500+', 'Acres of Olive Groves')),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildMetricCard(Icons.people, '50+', 'Team Members')),
            const SizedBox(width: 12),
            Expanded(child: _buildMetricCard(Icons.emoji_events, '25+', 'Industry Awards')),
          ],
        ),
      ],
    );
  }

  Widget _buildMetricCard(IconData icon, String number, String label) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF7B8B57),
            size: 32,
          ),
          const SizedBox(height: 8),
          Text(
            number,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOurValuesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Values',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          
          // Values in two columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildValueItem(Icons.eco, 'Sustainability', 'We practice sustainable farming methods, ensuring our land remains fertile for future generations while minimizing our environmental impact.'),
                    const SizedBox(height: 20),
                    _buildValueItem(Icons.star_outline, 'Quality First', 'We never compromise on quality, from the selection of our olive varieties to the final bottling process.'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildValueItem(Icons.favorite_outline, 'Family Tradition', 'Every bottle carries the love and care of our family, maintaining the same attention to detail that Maria brought to our first harvest.'),
                    const SizedBox(height: 20),
                    _buildValueItem(Icons.people_outline, 'Community', 'We\'re proud to be part of the Sutter Buttes community and support local farmers, artisans, and businesses.'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(IconData icon, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF7B8B57),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
             ],
     );
   }

  Widget _buildOurProcessSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Our Process',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          
          // Process steps in horizontal layout
          Row(
            children: [
              Expanded(
                child: _buildProcessStep('1', 'Harvesting', 'We hand-harvest our olives at peak ripeness, ensuring the perfect balance of flavor and aroma.'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProcessStep('2', 'Cold Pressing', 'Within hours of harvest, our olives are cold-pressed to preserve their natural flavors and nutrients.'),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildProcessStep('3', 'Bottling', 'Each batch is carefully bottled and labeled by hand, ensuring the highest quality control.'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProcessStep(String number, String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF7B8B57),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey[700],
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildOurLocationSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.location_on,
                color: Colors.grey[800],
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Our Location',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Nestled in the heart of California\'s Sutter Buttes, our farm benefits from the region\'s unique microclimate and rich soil. The Sutter Buttes, often called the "World\'s Smallest Mountain Range," provides the perfect conditions for growing exceptional olives.',
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          
          // Visit Our Farm subsection
          Text(
            'Visit Our Farm',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          
          // Contact information
          _buildContactInfo('Address', '1234 Olive Grove Lane, Sutter Buttes, CA 95982'),
          const SizedBox(height: 8),
          _buildContactInfo('Hours', 'Tuesday - Sunday, 10 AM - 5 PM'),
          const SizedBox(height: 8),
          _buildContactInfo('Phone', '(555) 123-4567'),
          const SizedBox(height: 8),
          _buildContactInfo('Email', 'visit@sutterbuttes.com'),
        ],
      ),
    );
  }

  Widget _buildContactInfo(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
             ],
     );
   }

  Widget _buildAwardsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Awards & Recognition',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 20),
          
          // Awards in two columns
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildAwardItem('2023', 'California Olive Oil Council', 'Best Extra Virgin Olive Oil - Gold Medal'),
                    const SizedBox(height: 16),
                    _buildAwardItem('2021', 'Sustainable Farming Award', 'Awarded by: California Department of Agriculture'),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildAwardItem('2022', 'International Olive Oil Competition', 'Premium Quality Award'),
                    const SizedBox(height: 16),
                    _buildAwardItem('2020', 'Family Business of the Year', 'Awarded by: Sutter County Chamber of Commerce'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAwardItem(String year, String awardName, String details) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          year,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          awardName,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 2),
        Text(
          details,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
            height: 1.3,
          ),
        ),
             ],
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
          Text(
            'Experience the Difference',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A3D4D),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Taste the tradition, quality, and passion in every drop of Sutter Buttes olive oil.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),
          
          // Buttons Row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 50, // fixed button height
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
                      elevation: 0,
                    ),
                    child: const Text(
                      'Shop Our Products',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 50, // same fixed height
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RecipesScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF7B8B57),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Explore Recipes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          )


        ],
      ),
    );
  }
 }
