import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {


  String _searchQuery = '';
  bool _isSearching = false;
  List<Map<String, dynamic>> _filteredResults = [];

  final TextEditingController _searchController = TextEditingController();
  final Map<String, bool> _expandedItems = {};

  final List<Map<String, dynamic>> _accountQuestions = [
    {
      'question': 'How do I create an account?',
      'answer': 'You can create an account by clicking the \'Sign Up\' button on the login page. You\'ll need to provide your email address, create a password, and fill in your basic information.',
      'expanded': true,
    },
    {
      'question': 'How do I update my profile information?',
      'answer': 'To update your profile information, go to your profile page and tap the edit button. You can modify your name, email, profile picture, and other personal details.',
      'expanded': false,
    },
    {
      'question': 'I forgot my password. How do I reset it?',
      'answer': 'On the login page, tap the "Forgot Password?" link. Enter your email address and follow the instructions sent to your email to reset your password.',
      'expanded': false,
    },
    /*{
      'question': 'How do I manage my notification preferences?',
      'answer': 'Go to your profile settings and select "Notification Preferences". Here you can choose which types of notifications you want to receive and how often.',
      'expanded': false,
    },*/
  ];

  final List<Map<String, dynamic>> _recipeQuestions = [
    {
      'question': 'How do I save a recipe to my favorites?',
      'answer': 'When viewing a recipe, tap the heart icon in the top right corner to save it to your favorites. You can access all your saved recipes from the Favorites tab.',
      'expanded': false,
    },
    /*{
      'question': 'Can I print recipes?',
      'answer': 'Yes! When viewing a recipe, tap the share icon and select "Print" to print the recipe or save it as a PDF.',
      'expanded': false,
    },*/
    {
      'question': 'How do I search for specific recipes?',
      'answer': 'Use the search bar at the top of the recipes page. You can search by ingredients, recipe name.',
      'expanded': false,
    },
    /*{
      'question': 'Are the recipes suitable for different dietary restrictions?',
      'answer': 'Yes, our recipes include various dietary options. Use the filter button to find recipes that are vegetarian, vegan, gluten-free, or meet other dietary requirements.',
      'expanded': false,
    },*/
  ];

  final List<Map<String, dynamic>> _shoppingQuestions = [
    {
      'question': 'How do I add items to my cart?',
      'answer': 'Browse our products and tap the "Add to Cart" button on any item you want to purchase. You can adjust quantities in your cart before checkout.',
      'expanded': false,
    },
    /*{
      'question': 'What payment methods do you accept?',
      'answer': 'We accept all major credit cards (Visa, MasterCard, American Express), PayPal, and Apple Pay for secure and convenient payments.',
      'expanded': false,
    },*/
    /*{
      'question': 'How long does shipping take?',
      'answer': 'Standard shipping takes 3-5 business days. Express shipping (1-2 business days) is available for an additional fee. International shipping may take 7-14 days.',
      'expanded': false,
    },*/
    /*{
      'question': 'Can I track my order?',
      'answer': 'Yes! Once your order ships, you\'ll receive a tracking number via email. You can also track your order status in your account dashboard.',
      'expanded': false,
    },*/
   /* {
      'question': 'What is your return policy?',
      'answer': 'We offer a 30-day return policy for unused items in original packaging. Contact our customer service team to initiate a return.',
      'expanded': false,
    },*/
  ];

  final List<Map<String, dynamic>> _productsQuestions = [
    /*{
      'question': 'Where are your olive oils sourced from?',
      'answer': 'Our olive oils are sourced from premium olive groves in California\'s Central Valley, specifically from family-owned farms that have been producing high-quality olives for generations.',
      'expanded': false,
    },*/
    /*{
      'question': 'Are your products organic?',
      'answer': 'Yes, all our products are certified organic. We work exclusively with organic farmers and use sustainable farming practices to ensure the highest quality and environmental responsibility.',
      'expanded': false,
    },*/
    /*{
      'question': 'How should I store olive oil?',
      'answer': 'Store olive oil in a cool, dark place away from direct sunlight and heat sources. Keep it tightly sealed and use within 18 months of opening for best flavor and quality.',
      'expanded': false,
    },*/
    /*{
      'question': 'Do you offer gift cards?',
      'answer': 'Yes, we offer gift cards in various denominations. They can be purchased online and are perfect for food lovers who appreciate high-quality, artisanal products.',
      'expanded': false,
    },*/
  ];

  final List<Map<String, dynamic>> _contactQuestions = [

    {
      'question': 'How can I contact customer service?',
      'answer': 'You can reach our customer service team by phone at  (530)-763-7921, email at Sales@Sutterbuttesoliveoil.com, or through the contact form on our website. We typically respond within 48 hours.',
      'expanded': false,
    },

  /*  {
      'question': 'What are your customer service hours?',
      'answer': 'Our customer service team is available Monday through Friday, 9:00 AM to 6:00 PM PST. For urgent matters outside these hours, please email us and we\'ll respond as soon as possible.',
      'expanded': false,
    },*/

    {
      'question': 'Do you have a physical store?',
      'answer': 'Yes, we have a physical store Sutter Buttes Natural and Artisan Foods, 1670 Poole Blvd, Yuba City, CA 95993.',
      'expanded': false,
    },


    /*{
      'question': 'Can I schedule a tasting appointment?',
      'answer': 'Absolutely! We offer guided tastings at our store by appointment. Contact us to schedule a tasting session where you can sample our various olive oils and learn about their unique characteristics.',
      'expanded': false,
    },*/
  ];

  @override
  void initState() {
    super.initState();


    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
        _isSearching = _searchQuery.isNotEmpty;
        _filterFAQs();
      });
    });










    // Initialize expanded state for all questions
    for (int i = 0; i < _accountQuestions.length; i++) {
      _expandedItems['account_$i'] = _accountQuestions[i]['expanded'];
    }
    for (int i = 0; i < _recipeQuestions.length; i++) {
      _expandedItems['recipe_$i'] = _recipeQuestions[i]['expanded'];
    }
    for (int i = 0; i < _shoppingQuestions.length; i++) {
      _expandedItems['shopping_$i'] = _shoppingQuestions[i]['expanded'];
    }
    for (int i = 0; i < _productsQuestions.length; i++) {
      _expandedItems['products_$i'] = _productsQuestions[i]['expanded'];
    }
    for (int i = 0; i < _contactQuestions.length; i++) {
      _expandedItems['contact_$i'] = _contactQuestions[i]['expanded'];
    }
  }



  void _filterFAQs() {
    final allQuestions = [
      ..._accountQuestions,
      ..._recipeQuestions,
      ..._shoppingQuestions,
      ..._productsQuestions,
      ..._contactQuestions,
    ];
    setState(() {
      if (_searchQuery.isEmpty) {
        _filteredResults = [];
      } else {
        _filteredResults = allQuestions.where((q) {
          final question = q['question'].toString().toLowerCase();
          final answer = q['answer'].toString().toLowerCase();
          return question.contains(_searchQuery) || answer.contains(_searchQuery);
        }).toList();
      }
    });
  }







  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _toggleExpanded(String key) {
    setState(() {
      _expandedItems[key] = !(_expandedItems[key] ?? false);
    });
  }

  Widget _buildClickableAnswer(String answer) {

    final phonePattern = RegExp(r'\(\d{3}\)-\d{3}-\d{4}');
    final emailPattern = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b');

    List<TextSpan> spans = [];
    int lastIndex = 0;

    // Find all matches
    final phoneMatch = phonePattern.firstMatch(answer);
    final emailMatch = emailPattern.firstMatch(answer);

    // Create a list of matches with their positions
    List<({int start, int end, String text, String type})> matches = [];

    if (phoneMatch != null) {
      matches.add((
      start: phoneMatch.start,
      end: phoneMatch.end,
      text: phoneMatch.group(0)!,
      type: 'phone'
      ));
    }

    if (emailMatch != null) {
      matches.add((
      start: emailMatch.start,
      end: emailMatch.end,
      text: emailMatch.group(0)!,
      type: 'email'
      ));
    }

    // Sort matches by position
    matches.sort((a, b) => a.start.compareTo(b.start));

    // Build text spans
    for (var match in matches) {
      // Add text before match
      if (match.start > lastIndex) {
        spans.add(TextSpan(
          text: answer.substring(lastIndex, match.start),
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
            height: 1.5,
          ),
        ));
      }

      // Add clickable match
      spans.add(TextSpan(
        text: match.text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.lightBlue,
          height: 1.5,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () async {
            if (match.type == 'phone') {
              final phoneNumber = match.text.replaceAll(RegExp(r'[^\d]'), ''); // Remove all non-digits (parentheses, dots, etc.)
              final uri = Uri.parse('tel:$phoneNumber');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            } else if (match.type == 'email') {
              final uri = Uri.parse('mailto:${match.text}');
              if (await canLaunchUrl(uri)) {
                await launchUrl(uri);
              }
            }
          },
      ));

      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < answer.length) {
      spans.add(TextSpan(
        text: answer.substring(lastIndex),
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.5,
        ),
      ));
    }

    // If no matches found, return regular text
    if (spans.isEmpty) {
      return Text(
        answer,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.5,
        ),
      );
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Help Center',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w300,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 40),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for answers...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _isSearching
                      ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.grey),
                    onPressed: () {
                      _searchController.clear();
                    },
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),

            if (_isSearching)
              _filteredResults.isEmpty
                  ? const Text(
                'No results found.',
                style: TextStyle(color: Colors.grey),
              )
                  : Column(
                children: _filteredResults.map((question) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ExpansionTile(
                      title: Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          /*child: Text(
                            question['answer'],
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              height: 1.5,
                            ),
                          ),*/
                          child: _buildClickableAnswer(question['answer']),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              )
            else ...[
              _buildFAQSection('Account & Profile', Icons.person, _accountQuestions, 'account'),
              const SizedBox(height: 30),
              _buildFAQSection('Recipes & Cooking', Icons.restaurant, _recipeQuestions, 'recipe'),
              const SizedBox(height: 30),
              _buildFAQSection('Shopping & Orders', Icons.shopping_cart, _shoppingQuestions, 'shopping'),
              //_buildFAQSection('Products & Quality', Icons.inventory, _productsQuestions, 'products'),
              const SizedBox(height: 30),
              _buildFAQSection('Contact & Support', Icons.email, _contactQuestions, 'contact'),
            ],
          ],
        ),
      ),

    );
  }

  Widget _buildFAQSection(
    String title,
    IconData icon,
    List<Map<String, dynamic>> questions,
    String sectionKey,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          children: [
            Icon(icon, color: Colors.grey[600], size: 24),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Questions
        ...questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          final key = '${sectionKey}_$index';

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: ExpansionTile(
              key: Key(key),
              initiallyExpanded: _expandedItems[key] ?? false,
              onExpansionChanged: (expanded) => _toggleExpanded(key),
              title: Text(
                question['question'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  /*child: Text(
                    question['answer'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                      height: 1.5,
                    ),
                  ),*/
                  child: _buildClickableAnswer(question['answer']),
                ),
              ],
            ),
          );
                 }).toList(),
       ],
     );
   }


   Widget _buildContactOption(IconData icon, String label, VoidCallback onTap) {
     return GestureDetector(
       onTap: onTap,
       child: Column(
         children: [
           Container(
             padding: const EdgeInsets.all(12),
             decoration: BoxDecoration(
               color: Colors.grey[100],
               borderRadius: BorderRadius.circular(8),
               border: Border.all(color: Colors.grey[300]!),
             ),
             child: Icon(
               icon,
               color: const Color(0xFF4A3D4D),
               size: 24,
             ),
           ),
           const SizedBox(height: 8),
           Text(
             label,
             style: const TextStyle(
               fontSize: 12,
               fontWeight: FontWeight.w500,
               color: Color(0xFF4A3D4D),
             ),
           ),
         ],
       ),
     );
   }
 }
