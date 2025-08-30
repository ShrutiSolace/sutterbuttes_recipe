import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static const Color _brandGreen = Color(0xFF7B8B57);

  @override
  Widget build(BuildContext context) {
    value: SystemUiOverlayStyle.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 6),
              _buildBrandHeader(),
              const SizedBox(height: 16),
              Text(
                'Reset Your Password',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter your email address and we\'ll send you a link to reset your password',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Card container
              Card(
                elevation: 0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: BorderSide(color: Colors.black.withOpacity(0.08)),
                ),
                                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
                   child: Form(
                     key: _formKey,
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                      Center(
                        child: Text(
                          'Reset Password',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Email field
                      Text('Email Address',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: Colors.black87)),
                      const SizedBox(height: 6),
                                             TextFormField(
                         controller: _emailController,
                         keyboardType: TextInputType.emailAddress,
                         validator: (value) {
                           if (value == null || value.isEmpty) {
                             return 'Email is required';
                           }
                           if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                             return 'Please enter a valid email';
                           }
                           return null;
                         },
                         decoration: _inputDecoration(
                           hint: 'Enter your email address',
                           context: context,
                         ),
                       ),
                      const SizedBox(height: 20),

                                             // Send reset link button
                       SizedBox(
                         width: double.infinity,
                         child: ElevatedButton(
                           onPressed: () {
                             if (_formKey.currentState!.validate()) {
                               // Handle send reset link
                               _showResetLinkSentDialog(context);
                             }
                           },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _brandGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Send Reset Link'),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Back to login link
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: _brandGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 4)),
                          child: const Text('Back to Sign In'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(
      {required String hint, required BuildContext context}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.black.withOpacity(0.2)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: _brandGreen, width: 1.2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red, width: 1.2),
      ),
      errorStyle: const TextStyle(
        color: Colors.red,
        fontSize: 12,
      ),
    );
  }

  Widget _buildBrandHeader() {
    return Center(
      child: Image.asset(
        'assets/images/Sutter Buttes Logo.png',
        height: 120,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return const Text(
            'SUTTER BUTTES',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          );
        },
      ),
    );
  }

  void _showResetLinkSentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: _brandGreen,
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Reset Link Sent',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          content: Text(
            'We\'ve sent a password reset link to ${_emailController.text.isEmpty ? 'your email' : _emailController.text}. Please check your inbox and follow the instructions to reset your password.',
            style: const TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to login screen
              },
              child: Text(
                'OK',
                style: TextStyle(color: _brandGreen, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }
}
