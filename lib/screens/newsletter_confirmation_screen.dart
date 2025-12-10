import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/profile_screen.dart';
import 'package:sutterbuttes_recipe/screens/state/newsletter_provider.dart';

class NewsletterConfirmationScreen extends StatelessWidget {
  const NewsletterConfirmationScreen({super.key});

  static const Color _brandGreen = Color(0xFF7B8B57);
  static const Color _darkGrey = Color(0xFF4A3D4D);
  static const Color _textGrey = Color(0xFF5F6368);


  @override


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //_buildBrandHeader(),
            const SizedBox(height: 40),
            _buildConfirmationCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'SUTTER BUTTES',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: _darkGrey,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          height: 1,
          width: 200,
          color: Colors.grey[300],
        ),
        const SizedBox(height: 8),
        const Text(
          'Shop , Cook & Savor',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: _darkGrey,
            letterSpacing: 0.5,
            fontStyle: FontStyle.italic,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: List.generate(
            5,
                (index) => Container(
              margin: const EdgeInsets.only(right: 4),
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: _darkGrey.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// ✅ Now it accepts context
  Widget _buildConfirmationCard(BuildContext context) {
    return Center(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            _buildSuccessIcon(),
            const SizedBox(height: 24),
            const Text(
              'Welcome to Sutter Buttes!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _darkGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'You\'re now subscribed to our newsletter. Look out for delicious recipes, cooking tips, and exclusive offers in your inbox.',
              style: TextStyle(
                fontSize: 16,
                color: _textGrey,
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 32),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessIcon() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: _brandGreen.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(
          color: _brandGreen.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _brandGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _brandGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Back to Profile',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              _showUnsubscribeDialog(context);
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Unsubscribe',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _textGrey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showUnsubscribeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Consumer<NewsletterProvider>(
          builder: (context, newsletterProvider, child) {
            return AlertDialog(
              title: const Text('Unsubscribe'),
              content: const Text(
                'Are you sure you want to unsubscribe from our newsletter?',
              ),
              actions: [
                TextButton(
                  onPressed: newsletterProvider.isLoading
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: _brandGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: newsletterProvider.isLoading
                      ? null
                      : () => _handleUnsubscribe(context, dialogContext),
                  style: TextButton.styleFrom(
                    backgroundColor: _brandGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: newsletterProvider.isLoading
                      ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : const Text('Unsubscribe'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _handleUnsubscribe(BuildContext context, BuildContext dialogContext) async {
    try {
      // Call the provider to unsubscribe
      await Provider.of<NewsletterProvider>(context, listen: false).unsubscribeFromNewsletter();

      // Close the dialog
      Navigator.of(dialogContext).pop();

      // Check if unsubscription was successful
      final provider = Provider.of<NewsletterProvider>(context, listen: false);
      if (provider.errorMessage == null) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have been unsubscribed successfully.'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to home/profile
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Close the dialog
      Navigator.of(dialogContext).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to unsubscribe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}