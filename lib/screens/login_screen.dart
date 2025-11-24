import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sutterbuttes_recipe/screens/state/auth_provider.dart';
import '../services/notification_service.dart';
import 'bottom_navigation.dart';
import 'cart_screen.dart';
import 'forgot_password_screen.dart';
import 'package:provider/provider.dart';

import 'notifications_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});


  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameOrEmailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
 // String? _emailError;

  String? _usernameOrEmailError;
  String? _passwordError;

  void _handleGoogleSignIn(BuildContext context, AuthProvider authProvider) async {
    final success = await authProvider.signInWithGoogle();


    if (success) {
      await NotificationService.getToken();
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Google sign-in failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  void _handleAppleSignIn(BuildContext context, AuthProvider authProvider) async {
    final success = await authProvider.signInWithApple();

    if (success) {
      await NotificationService.getToken();
      Navigator.of(context).pushReplacementNamed('/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authProvider.errorMessage ?? 'Apple sign-in failed'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }









  static const Color _brandGreen = Color(0xFF7B8B57);
  static const Color _textGrey = Color(0xFF5F6368);

  void _clearFormFields() {
    _usernameOrEmailController.clear();
    _passwordController.clear();
  }



  @override
  Widget build(BuildContext context) {
    value:
    SystemUiOverlayStyle.dark;
    return Scaffold(
      backgroundColor: Colors.white,
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
                'Welcome',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Sign in to your Sutter Buttes account',
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
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16), // 🔹 Compact padding
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Center(
                          child: Text(
                            'Sign In',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Email field
                        Text('Username or Email Address', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _usernameOrEmailController,
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              _usernameOrEmailError = null;
                            });
                          },
                         /* validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username or email is required';
                            }
                            // Remove email validation - allow both username and email
                            return null;
                          },
                          */

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Username or email is required';
                            }

                            if (value.contains('@')) {
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                return 'Please enter a valid email address';
                              }

                              final parts = value.split('@');
                              if (parts.length != 2) return 'Please enter a valid email address';
                              final domain = parts[1];
                              if (!domain.contains('.') || domain.startsWith('.') || domain.endsWith('.') || domain.contains('..')) {
                                return 'Please enter a valid email domain';
                              }
                              final tld = domain.split('.').last;
                              if (tld.length < 2 || tld.length > 4) {
                                return 'Please enter a valid email domain';
                              }
                            }
                            else{
                              if (value.trim().length < 3) {
                                return 'Username must be at least 3 characters';
                              }
                            }
                            return null;
                          },


                          decoration: _inputDecoration(
                            hint: 'Enter your email',
                            context: context,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Password field
                        Text('Password', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onChanged: (value) {
                            setState(() {
                              _passwordError = null;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password is required';
                            }
                            if (value.length < 8) {
                              return 'Password must be at least 8 characters';
                            }
                            return null;
                          },
                          decoration: _inputDecoration(
                            hint: 'Enter your password',
                            context: context,
                            suffix: IconButton(
                              onPressed: () {
                                setState(() => _obscurePassword = !_obscurePassword);
                              },
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                                color: Colors.black45,
                              ),
                            ),
                          ),
                        ),

                        // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              _clearFormFields();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                              );
                            },
                            style: TextButton.styleFrom(foregroundColor: _brandGreen, padding: const EdgeInsets.symmetric(horizontal: 4)), //
                            child: const Text('Forgot password?'),
                          ),
                        ),

                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authProvider.isLoading
                                    ? null
                                    : () async {
                                  if (_formKey.currentState!.validate()) {
                                    final success = await authProvider.login(
                                      username: _usernameOrEmailController.text.trim(),
                                      password: _passwordController.text,
                                    );
                                    if (success) {
                                      await NotificationService.getToken();

                                      // Show success toast/snackbar
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('Login successful!'),
                                          backgroundColor: const Color(0xFF7B8B57),
                                          behavior: SnackBarBehavior.floating, // shows at bottom floating
                                          margin: const EdgeInsets.all(0), // adds some spacing from edges
                                          duration: const Duration(seconds: 2),
                                        ),
                                      );

                                      // Navigate after a short delay to let user see the message
                                      await Future.delayed(const Duration(milliseconds: 100));
                                     // Navigator.of(context).pushReplacementNamed('/home');


                                      //  Check if there's an attempted action
                                      final attemptedAction = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

                                      if (attemptedAction != null) {
                                        final action = attemptedAction['action'];

                                        if (action == 'add_to_cart') {
                                          // Return to product screen with pending action
                                          Navigator.of(context).pop(attemptedAction);
                                        }
                                        else if (action == 'mark_favorite') {

                                          Navigator.of(context).pop(attemptedAction);
                                        }

                                        else if (action == 'favorites') {
                                          //  Navigate to Favorites screen
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const BottomNavigationScreen(initialIndex: 3),
                                            ),
                                          );
                                        }
                                        else if (action == 'view notifications') {

                                          Navigator.of(context).pop();
                                        }

                                        else if (action == 'profile') {
                                          // Navigate to Profile screen
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => const BottomNavigationScreen(initialIndex: 4),
                                            ),
                                          );
                                        }
                                     else if (action == 'cart') {
                                         Navigator.of(context).pop();
                                         /*Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                          builder: (context) => const CartScreen(),
                                            ),
                                           );*/
                                        }

                                     else if (action == 'favorites') {
                                          Navigator.of(context).pop();
                                        }
                                        else {

                                          Navigator.of(context).pushReplacementNamed('/home');
                                        }
                                      } else {

                                        Navigator.of(context).pushReplacementNamed('/home');
                                      }



                                    }
                                   /* else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Invalid credentials.Please try again',
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                           margin : const EdgeInsets.all(0),


                                        ),
                                      );
                                    }*/
                                    else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                              authProvider.errorMessage ?? 'Invalid credentials. Please try again.'
                                          ),
                                          backgroundColor: Colors.red,
                                          duration: const Duration(seconds: 3),
                                          behavior: SnackBarBehavior.floating,
                                          margin: const EdgeInsets.all(0),
                                        ),
                                      );
                                    }
                                  }
                                },

                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _brandGreen,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                ),
                                child: authProvider.isLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.0,
                                      )
                                    : const Text('Sign In'),
                              ),
                            );
                          },
                        ),

                       /* const SizedBox(height: 12),
                        _OrDivider(color: Colors.black.withOpacity(0.2)),
                        const SizedBox(height: 12),*/

                        // Google sign in
                       /* Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return _SocialButton(
                              label: 'Continue with Google',
                              icon: const _GoogleIcon(),
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () {
                                      _handleGoogleSignIn(context, authProvider);
                                    },
                            );
                          },
                        ),*/
/*
                        const SizedBox(height: 8),

                        Consumer<AuthProvider>(
                          builder: (context, authProvider, child) {
                            return _SocialButton(
                              label: 'Continue with Apple',
                              icon: const _AppleIcon(),
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () {
                                _handleAppleSignIn(context, authProvider);
                              },
                            );
                          },
                        ),*/

                        // Facebook
                     /*  _SocialButton(
                          label: 'Continue with Facebook',
                          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                          onPressed: () async {
                            final authProvider = Provider.of<AuthProvider>(context, listen: false);
                            final success = await authProvider.signInWithFacebook();

                            if (success) {
                              await NotificationService.getToken();
                              Navigator.of(context).pushReplacementNamed('/home');
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(authProvider.errorMessage ?? 'Facebook sign-in failed'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          },
                        ),*/
                        const SizedBox(height: 12),

                        // Signup link
                        Center(
                          child: RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black),
                              children: <TextSpan>[
                                const TextSpan(text: "Don't have an account? "),
                                TextSpan(
                                  text: 'Sign up',
                                  style: const TextStyle(color: _brandGreen, fontWeight: FontWeight.w600),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context).pushNamed('/signup');
                                    },
                                ),
                              ],
                            ),
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

  InputDecoration _inputDecoration({required String hint, required BuildContext context, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12), // 🔹 Slimmer fields
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
      suffixIcon: suffix,
    );
  }

  Widget _buildBrandHeader() {
    return Center(
      child: Image.asset(
        'assets/images/artisan foods logo.jpg',
        height: 120, // 🔹 Increased logo size for better visibility
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
}

class _OrDivider extends StatelessWidget {
  final Color color;
  const _OrDivider({required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: color)),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Text(
            'or',
            style: TextStyle(color: Colors.black54, fontSize: 12),
          ),
        ),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onPressed;

  const _SocialButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10), // 🔹 Smaller button
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black87,
          side: BorderSide(color: Colors.black.withOpacity(0.2)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}

class _GoogleIcon extends StatelessWidget {
  const _GoogleIcon();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/google icon.png',
      width: 20,
      height: 20,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return const CircleAvatar(
          radius: 9,
          backgroundColor: Colors.white,
          child: Text(
            '',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        );
      },
    );
  }
}

class _AppleIcon extends StatelessWidget {
  const _AppleIcon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.apple,
      size: 24,
      color: Colors.black87,
    );
  }
}