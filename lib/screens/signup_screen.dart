import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/notification_service.dart';
import 'state/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _emailError;
  String? _passwordError;
  final _formKey = GlobalKey<FormState>();

  static const Color _brandGreen = Color(0xFF7B8B57);

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 4),
              _buildBrandHeader(),
              const SizedBox(height: 8),
              Text(
                'Join Sutter Buttes',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 4),
              Text(
                'Create your account to get started',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 520),
                  child: Card(
                    elevation: 0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.black.withOpacity(0.08)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Form( // <-- ADDED FORM
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Center(
                              child: Text(
                                'Create Account',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('First Name', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _firstNameController,
                                        decoration: _inputDecoration(hint: 'First name'),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'First name is required';
                                          }
                                          if (!RegExp(r'^[A-Za-z]{2,}$').hasMatch(value.trim())) {
                                            return 'Please enter a valid first name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text('Last Name', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                                      const SizedBox(height: 4),
                                      TextFormField(
                                        controller: _lastNameController,
                                        decoration: _inputDecoration(hint: 'Last name'),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) {
                                            return 'Last name is required';
                                          }
                                          if (!RegExp(r'^[A-Za-z]{2,}$').hasMatch(value.trim())) {
                                            return 'Please enter a valid Last name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text('Username', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _usernameController,
                              decoration: _inputDecoration(hint: 'Username'),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Username is required';
                                }


                                if (!RegExp(r'^[A-Za-z0-9._]+$').hasMatch(value.trim())) {
                                  return 'Only letters, numbers, dots, and underscores are allowed';
                                }


                                if (value.trim().length < 3) {
                                  return 'Username must be at least 3 characters';
                                }
                                if (value.trim().length > 20) {
                                  return 'Username must be less than 20 characters';
                                }

                                return null;
                              },

                            ),
                            const SizedBox(height: 12),
                            Text('Email Address', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: _inputDecoration(hint: 'Enter your email'),
                              onChanged: (value) {
                                setState(() {
                                  _emailError = null;
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Text('Password', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
                              decoration: _inputDecoration(
                                hint: 'Create a password',
                                suffix: IconButton(
                                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                    color: Colors.black45,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Password is required';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Text('Confirm Password', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                            const SizedBox(height: 4),
                            TextFormField( // <-- Changed to TextFormField
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              decoration: _inputDecoration(
                                hint: 'Confirm your password',
                                suffix: IconButton(
                                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                  icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.black45),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirm password is required';
                                }
                                if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: authProvider.isLoading ? null : () async {
                                      if (_formKey.currentState!.validate()) {
                                        // Call sign up API
                                        final success = await authProvider.signUp(
                                          username: _usernameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          firstName: _firstNameController.text,
                                          lastName: _lastNameController.text,
                                        );
                                       /* if (success) {
                                          Navigator.of(context).pushReplacementNamed('/login');
                                        }
                                        */

                                        if (success) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Registration successful! Please sign in.'),
                                              backgroundColor: Color(0xFF7B8B57),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );

                                          await Future.delayed(const Duration(milliseconds: 300));
                                          Navigator.of(context).pushReplacementNamed('/login');
                                        }
                                        else {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(content: Text(authProvider.errorMessage ?? 'Sign up failed')),
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
                                    ) : const Text('Create Account'),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 12),
                            _OrDivider(color: Colors.black.withOpacity(0.2)),
                            const SizedBox(height: 12),


                            // Google sign in
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, child) {
                                return _SocialButton(
                                  label: 'Continue with Google',
                                  icon: const _GoogleIcon(),
                                  onPressed: () {  // ← FIXED: Remove the null check
                                    _handleGoogleSignIn(context, authProvider);
                                  },
                                );
                              },
                            ),

                            const SizedBox(height: 8),
                            /*_SocialButton(
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
                            ),
*/



                            const SizedBox(height: 12),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black54),
                                  children: <TextSpan>[
                                    const TextSpan(text: 'Already have an account? '),
                                    TextSpan(
                                      text: 'Sign in here',
                                      style: const TextStyle(color: _brandGreen, fontWeight: FontWeight.w600),
                                      recognizer: TapGestureRecognizer()..onTap = () {
                                        Navigator.of(context).pushReplacementNamed('/login');
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
      suffixIcon: suffix,
    );
  }

  Widget _buildBrandHeader() {
    return Center(
      child: Image.asset(
        'assets/images/Sutter Buttes Logo.png',
        height: 80,
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            'or continue with',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.black54),
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
  final VoidCallback onPressed;

  const _SocialButton({required this.label, required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: icon,
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(label),
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
      'assets/images/google_logo.png',
      width: 18,
      height: 18,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return const CircleAvatar(
          radius: 10,
          backgroundColor: Colors.white,
          child: Text(
            'G',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
      },
    );
  }
}
