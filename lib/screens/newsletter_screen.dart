import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/state/newsletter_provider.dart';
import 'newsletter_confirmation_screen.dart';

class NewsletterScreen extends StatefulWidget {
  const NewsletterScreen({super.key});

  @override
  State<NewsletterScreen> createState() => _NewsletterScreenState();
}

class _NewsletterScreenState extends State<NewsletterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();

  bool _newRecipes = true;
  bool _cookingTips = true;
  bool _seasonalOffers = false;
  bool _productUpdates = true;
  bool _consentAgreed = false;

  static const Color _brandGreen = Color(0xFF7B8B57);
  static const Color _textGrey = Color(0xFF5F6368);
  static const Color _darkGrey = Color(0xFF4A3D4D);


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NewsletterProvider>(context, listen: false).fetchNewsletterData();
    });
  }







  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Newsletter Subscription',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,

          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      //replace with provider to manage state
      body: Consumer<NewsletterProvider>(
        builder: (context, newsletterProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                _buildBrandHeader(),
                const SizedBox(height: 24),


                _buildNewsletterForm(),


                if (newsletterProvider.subscribeResponse != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.green[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            newsletterProvider.subscribeResponse!.message,
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ),
                      ],
                    ),
                  ),

                if (newsletterProvider.errorMessage != null)
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red[200]!),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red[600], size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            newsletterProvider.errorMessage!,
                            style: TextStyle(color: Colors.red[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 10),
        const Text(
          'Stay updated with our latest recipes and offers',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNewsletterForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Form Header
            Row(
              children: [
                const Icon(Icons.email_outlined, color: _darkGrey, size: 20),
                const SizedBox(width: 8),
                const Text(
                  'Subscribe to Our Newsletter',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _darkGrey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Email Field
            _buildInputField(
              label: 'Email Address *',
              controller: _emailController,
              icon: Icons.email_outlined,
              hint: 'Enter your email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // First Name Field
            _buildInputField(
                label: 'First Name',
                controller: _firstNameController,
                icon: Icons.person_outline,
                hint: 'Enter your first name',
                validator: (value){
                  if(value == null || value.isEmpty){
                    return 'Please enter your first name';
                  }
                  return null;
                }
            ),
            const SizedBox(height: 20),

            // Newsletter Preferences
            _buildNewsletterPreferences(),
            const SizedBox(height: 20),

            // Consent Checkbox
            _buildConsentCheckbox(),
            const SizedBox(height: 24),

            // Action Buttons
            _buildActionButtons(),
            const SizedBox(height: 24),

            // What to Expect Section
            _buildWhatToExpect(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: _darkGrey,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: _textGrey, size: 20),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: _brandGreen, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNewsletterPreferences() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.restaurant_menu, color: _darkGrey, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Newsletter Preferences',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _darkGrey,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildCheckboxOption('New Recipes', _newRecipes, (value) {
          setState(() => _newRecipes = value!);
        }),
        _buildCheckboxOption('Cooking Tips & Techniques', _cookingTips, (value) {
          setState(() => _cookingTips = value!);
        }),
        _buildCheckboxOption('Seasonal Offers & Promotions', _seasonalOffers, (value) {
          setState(() => _seasonalOffers = value!);
        }),
        _buildCheckboxOption('New Product Updates', _productUpdates, (value) {
          setState(() => _productUpdates = value!);
        }),
      ],
    );
  }

  Widget _buildCheckboxOption(String title, bool value, ValueChanged<bool?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: _brandGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: _darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsentCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: _consentAgreed,
          onChanged: (value) {
            setState(() => _consentAgreed = value!);
          },
          activeColor: _brandGreen,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 12,
                color: _textGrey,
                height: 1.4,
              ),
              children: [
                const TextSpan(text: 'I agree to receive email newsletters from Sutter Buttes Olive Oil. I understand that I can unsubscribe at any time. '),
                WidgetSpan(
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navigate to privacy policy
                    },
                    child: const Text(
                      'View Privacy Policy',
                      style: TextStyle(
                        color: _brandGreen,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
//actions buttons
  Widget _buildActionButtons() {
    return Consumer<NewsletterProvider>(
      builder: (context, newsletterProvider, child) {
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: newsletterProvider.isLoading ? null : () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey[300]!),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                    color: _textGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: (newsletterProvider.isLoading || !_consentAgreed) ? null : _handleSubscribe,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _brandGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: newsletterProvider.isLoading
                    ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Icon(Icons.email, size: 18),
                label: Text(
                  newsletterProvider.isLoading ? 'Subscribing...' : 'Subscribe',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  Widget _buildWhatToExpect() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'What to Expect',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: _darkGrey,
          ),
        ),
        const SizedBox(height: 12),
        _buildExpectationItem('Weekly recipe collections and cooking inspiration'),
        _buildExpectationItem('Exclusive access to seasonal promotions and discounts'),
        _buildExpectationItem('Tips for using our premium olive oils and vinegars'),
        _buildExpectationItem('Behind-the-scenes stories from our California farm'),
      ],
    );
  }

  Widget _buildExpectationItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 4,
            height: 4,
            decoration: const BoxDecoration(
              color: _brandGreen,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: _textGrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSubscribe() {
    if (_formKey.currentState!.validate() && _consentAgreed) {
      // Call the subscribe API
      _subscribeToNewsletter();
    } else if (!_consentAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _subscribeToNewsletter() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Call the provider to subscribe
      await Provider.of<NewsletterProvider>(context, listen: false).subscribeToNewsletter(
        email: _emailController.text,
        name: _firstNameController.text,
        newRecipes: _newRecipes,
        cookingTips: _cookingTips,
        seasonalOffers: _seasonalOffers,
        productUpdates: _productUpdates,
      );

      // Hide loading indicator
      Navigator.pop(context);

      // Check if subscription was successful
      final provider = Provider.of<NewsletterProvider>(context, listen: false);
      if (provider.subscribeResponse != null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.subscribeResponse!.message),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate to confirmation screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewsletterConfirmationScreen(),
          ),
        );
      } else if (provider.errorMessage != null) {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Hide loading indicator
      Navigator.pop(context);

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to subscribe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }




}
