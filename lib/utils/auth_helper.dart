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
        String? attemptedAction,
        String? favoriteType,
        int? favoriteId,



      }) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);


    if (authProvider.isLoggedIn) {
      return true;
    }


    if (showDialog) {
      final shouldLogin = await _showLoginPromptDialog(context, attemptedAction: attemptedAction);

      if (shouldLogin == true) {

        Map<String, dynamic>? pendingAction;
        if (productId != null && quantity != null) {
          pendingAction = {
            'action': 'add_to_cart',
            'productId': productId,
            'quantity': quantity,
            if (variationId != null) 'variationId': variationId,

          };
        }


        else if (attemptedAction == 'mark_favorite' && favoriteType != null && favoriteId != null) {
          pendingAction = {
            'action': 'mark_favorite',
            'favoriteType': favoriteType,
            'favoriteId': favoriteId,
          };
        }


        else if (attemptedAction != null) {
          pendingAction = {
            'action': attemptedAction,
          };
        }




        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginScreen(),
            settings: RouteSettings(arguments: pendingAction),
          ),
        );


        final authProviderAfterLogin = Provider.of<AuthProvider>(context, listen: false);
        return authProviderAfterLogin.isLoggedIn;
      }
      return false;
    }
    return false;
  }


  static Future<bool?> _showLoginPromptDialog(BuildContext context,{String? attemptedAction}) {
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
          content: Text(
            _getLoginMessage(attemptedAction),
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
  /*static String _getLoginMessage(String? attemptedAction) {
    switch (attemptedAction) {
      case 'favorites':
        return 'Please login to view your favorites recipes & products.';
      case 'profile':
        return 'Please login to view your profile.';
      case 'view notifications':
        return 'Please login to view your notifications.';
      case 'cart':
        return 'Please login to view your cart.';
      case 'add_to_cart':
      default:
        return 'Please login to add items to your cart.';
    }
  }*/


  static String _getLoginMessage(String? attemptedAction) {
    return 'Please login to browse recipes and products,create favorites, be informed about new promotions and more.';
  }
}
