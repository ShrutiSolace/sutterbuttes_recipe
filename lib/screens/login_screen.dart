import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  String? _emailError;
  String? _passwordError;

  static const Color _brandGreen = Color(0xFF7B8B57);
  static const Color _textGrey = Color(0xFF5F6368);

  @override
  Widget build(BuildContext context) {
    value: SystemUiOverlayStyle.dark;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // 🔹 Reduced padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 6), // 🔹 Smaller spacing
              _buildBrandHeader(),
              const SizedBox(height: 16), // 🔹 Reduced
              Text(
                'Welcome Back',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
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
                         decoration: _inputDecoration(
                           hint: 'Enter your email',
                           context: context,
                         ),
                       ),
                      const SizedBox(height: 12),

                                             // Password field
                       Text('Password',
                           style: Theme.of(context)
                               .textTheme
                               .labelLarge
                               ?.copyWith(color: Colors.black87)),
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
                           if (value.length < 6) {
                             return 'Password must be at least 6 characters';
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
                               _obscurePassword
                                   ? Icons.visibility_outlined
                                   : Icons.visibility_off_outlined,
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const ForgotPasswordScreen()),
                            );
                          },
                          style: TextButton.styleFrom(
                              foregroundColor: _brandGreen,
                              padding: const EdgeInsets.symmetric(horizontal: 4)), //
                          child: const Text('Forgot password?'),
                        ),
                      ),

                                             // Sign in button
                       SizedBox(
                         width: double.infinity,
                         child: ElevatedButton(
                           onPressed: () {
                             if (_formKey.currentState!.validate()) {
                               // Form is valid, proceed with login
                               Navigator.of(context).pushReplacementNamed('/home');
                             }
                           },
                           style: ElevatedButton.styleFrom(
                             backgroundColor: _brandGreen,
                             foregroundColor: Colors.white,
                             padding: const EdgeInsets.symmetric(vertical: 12), // 🔹 Slimmer
                             shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8)),
                           ),
                           child: const Text('Sign In'),
                         ),
                       ),

                      const SizedBox(height: 12),
                      _OrDivider(color: Colors.black.withOpacity(0.2)),
                      const SizedBox(height: 12),

                      // Google
                      _SocialButton(
                        label: 'Continue with Google',
                        icon: const _GoogleIcon(),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 8),

                      // Facebook
                      _SocialButton(
                        label: 'Continue with Facebook',
                        icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                        onPressed: () {},
                      ),
                      const SizedBox(height: 12),

                      // Signup link
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(color: Colors.black),
                            children: <TextSpan>[
                              const TextSpan(text: "Don't have an account? "),
                              TextSpan(
                                text: 'Sign up',
                                style: const TextStyle(
                                    color: _brandGreen, fontWeight: FontWeight.w600),
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

  InputDecoration _inputDecoration(
      {required String hint, required BuildContext context, Widget? suffix}) {
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
        'assets/images/Sutter Buttes Logo.png',
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
  final VoidCallback onPressed;

  const _SocialButton(
      {required this.label, required this.icon, required this.onPressed});

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
      'assets/images/google_logo.png',
      width: 100,
      height: 25,
      errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
        return const CircleAvatar(
          radius: 9,
          backgroundColor: Colors.white,
          child: Text(
            'G',
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
