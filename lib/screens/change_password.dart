import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/state/auth_provider.dart';
import '../repositories/profile_repository.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;
  bool _isSaving = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration(String hint, bool obscure, VoidCallback toggle) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      suffixIcon: IconButton(
        icon: Icon(obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
        onPressed: toggle,
      ),
    );
  }

  Future<void> _changePassword() async {
    final messenger = ScaffoldMessenger.of(context);
    FocusScope.of(context).unfocus();

    final currentPwd = _currentPasswordController.text.trim();
    final newPwd = _newPasswordController.text.trim();
    final confirmPwd = _confirmPasswordController.text.trim();

    // Validation
    if (currentPwd.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Please enter current password')));
      return;
    }
    if (newPwd.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Please enter new password')));
      return;
    }
    if (newPwd.length < 8) {
      messenger.showSnackBar(const SnackBar(content: Text('New password must be at least 8 characters')));
      return;
    }
    if (confirmPwd.isEmpty) {
      messenger.showSnackBar(const SnackBar(content: Text('Please confirm new password')));
      return;
    }
    if (newPwd != confirmPwd) {
      messenger.showSnackBar(const SnackBar(content: Text('New password and confirm password do not match')));
      return;
    }

    setState(() => _isSaving = true);

    try {
      final repo = UserRepository();
      final message = await repo.changePassword(
        currentPassword: currentPwd,
        newPassword: newPwd,
        confirmPassword: confirmPwd,
      );

      messenger.showSnackBar(SnackBar(content: Text(message)));

      /*if (message.toLowerCase().contains('success')) {
        Navigator.pop(context);
      }*/
      //messenger.showSnackBar(SnackBar(content: Text(message)));

      if (message.toLowerCase().contains('success')) {
        // Auto-logout user after password change
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.logout();

        // Navigate to login screen
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Failed to change password: $e')));
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F7F7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        title: const Text('Change Password', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Change Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: _obscureCurrent,
                decoration: _inputDecoration(
                  'Current Password',
                  _obscureCurrent,
                      () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newPasswordController,
                obscureText: _obscureNew,
                decoration: _inputDecoration(
                  'New Password',
                  _obscureNew,
                      () => setState(() => _obscureNew = !_obscureNew),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirm,
                decoration: _inputDecoration(
                  'Confirm Password',
                  _obscureConfirm,
                      () => setState(() => _obscureConfirm = !_obscureConfirm),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF4E944F)),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel', style: TextStyle(color: Color(0xFF4E944F))),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF77815C),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: _isSaving ? null : _changePassword,
                      child: _isSaving
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Save Changes', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
