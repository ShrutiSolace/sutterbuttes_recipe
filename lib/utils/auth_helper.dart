import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/state/auth_provider.dart';
import '../screens/login_screen.dart';

class AuthHelper {

  static Future<bool> checkAuthAndPromptLogin(
      BuildContext context, {
        bool showDialog = true,

        int? productId,
        int? quantity,
        int? variationId,



      }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);


    if (authProvider.isLoggedIn) {
      return true;
    }


    if (showDialog) {
      final shouldLogin = await _showLoginPromptDialog(context);

      if (shouldLogin == true) {
        // ✅ Create pending action map if product details are provided
        Map<String, dynamic>? pendingAction;
        if (productId != null && quantity != null) {
          pendingAction = {
            'action': 'add_to_cart',
            'productId': productId,
            'quantity': quantity,
            if (variationId != null) 'variationId': variationId,
          };
        }





        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
            settings: RouteSettings(arguments: pendingAction),  // ✅ Add this
          ),
        );


        final authProviderAfterLogin = Provider.of<AuthProvider>(context, listen: false);
        return authProviderAfterLogin.isLoggedIn;
      }
      return false;
    }
    return false;
  }


  static Future<bool?> _showLoginPromptDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Login Required',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF4A3D4D),
            ),
          ),
          content: const Text(
            'Please login to add items to your cart.',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF7B8B57),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }


  static bool isLoggedIn(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    return authProvider.isLoggedIn;
  }
}