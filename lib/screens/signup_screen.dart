import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  static const Color _brandGreen = Color(0xFF7B8B57);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 8),
              _buildBrandHeader(),
              const SizedBox(height: 16),
              Text(
                'Join Sutter Buttes',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              Text(
                'Create your account to get started',
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
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
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
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
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('First Name', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _firstNameController,
                                      decoration: _inputDecoration(hint: 'First name'),
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
                                    const SizedBox(height: 8),
                                    TextField(
                                      controller: _lastNameController,
                                      decoration: _inputDecoration(hint: 'Last name'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text('Email Address', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: _inputDecoration(hint: 'Enter your email'),
                          ),
                          const SizedBox(height: 16),
                          Text('Password', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: _inputDecoration(
                              hint: 'Create a password',
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                                icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.black45),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('Confirm Password', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black87)),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _confirmPasswordController,
                            obscureText: _obscureConfirmPassword,
                            decoration: _inputDecoration(
                              hint: 'Confirm your password',
                              suffix: IconButton(
                                onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                                icon: Icon(_obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Colors.black45),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {},
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _brandGreen,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Create Account'),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _OrDivider(color: Colors.black.withOpacity(0.2)),
                          const SizedBox(height: 16),
                          _SocialButton(
                            label: 'Continue with Google',
                            icon: const _GoogleIcon(),
                            onPressed: () {},
                          ),
                          const SizedBox(height: 12),
                          _SocialButton(
                            label: 'Continue with Facebook',
                            icon: const Icon(Icons.facebook, color: Color(0xFF1877F2)),
                            onPressed: () {},
                          ),
                          const SizedBox(height: 16),
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
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
          padding: const EdgeInsets.symmetric(vertical: 12),
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


