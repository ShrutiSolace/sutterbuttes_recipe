import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/notification_prefernce_setting.dart';
import 'package:sutterbuttes_recipe/screens/state/auth_provider.dart';
import 'package:sutterbuttes_recipe/screens/change_password.dart';
import '../modal/favourites_model.dart';
import '../repositories/favourites_repository.dart';
import '../repositories/order_repository.dart';
import '../services/google_signin_service.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';
import 'edit_profile_screen.dart';
import 'help_center_screen.dart';
import 'about_screen.dart';
import 'newsletter_screen.dart';
import 'orders_screen.dart';



class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3C47), // purple background
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Natural and Artisan Foods",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              Consumer<AuthProvider>(

                builder: (context, auth, _) {

                  final user = auth.me;
                  final name = user != null && (user.firstName.isNotEmpty || user.lastName.isNotEmpty)
                      ? '${user.firstName}'.trim()
                      : 'Guest';
                  final email = user?.email ?? '';
                  final avatar = user?.profileImage ?? '';

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black12,
                        backgroundImage: avatar.isNotEmpty ? NetworkImage(avatar) : null,
                        child: avatar.isEmpty
                            ? const Icon(Icons.person_outline, color: Colors.black54)
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.black, // ensure name is black
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),


              const SizedBox(height: 40),

              // Stats row
              Row(
                children: [
                  const SizedBox(width: 8),

                  // ✅ Dynamic Favorites count
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FavoritesScreen()),
                        );
                      },
                      child: FutureBuilder<FavouritesModel>(
                        future: FavouritesRepository().getFavourites(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {

                          }
                          if (snapshot.hasError || snapshot.data == null) {
                            return _StatCard(
                              icon: Icons.favorite_border,
                              title: 'Favorites',
                              value: '0',
                              iconColor: Colors.red,
                            );
                          }

                          final favourites = snapshot.data!;
                          final recipeCount = favourites.favorites?.recipes?.length ?? 0;
                          final productCount = favourites.favorites?.products?.length ?? 0;
                          final totalFavorites = recipeCount + productCount;

                          return _StatCard(
                            icon: Icons.favorite_border,
                            title: 'Favorites',
                            value: totalFavorites.toString(),
                            iconColor: Colors.red,
                          );
                        },
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Static Orders card (or you can make it dynamic too)
                  // Replace the static orders card in lib/screens/profile_screen.dart (around line 143-151)

                  // Static Orders card (or you can make it dynamic too)
                  // Orders card with navigation
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrdersScreen()),
                        );
                      },
                      child: FutureBuilder<int>(
                        future: OrderRepository().getCount(),
                        builder: (context, snapshot) {
                          print("=== FutureBuilder state: ${snapshot.connectionState}");
                          print("=== FutureBuilder hasData: ${snapshot.hasData}");
                          print("====FutureBuilder data: ${snapshot.data}");
                          print(" ====FutureBuilder error: ${snapshot.error}");

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return _StatCard(
                              icon: Icons.receipt_long_outlined,
                              title: 'Orders',
                              value: '0',
                              iconColor: Colors.amber,
                            );
                          }
                          if (snapshot.hasError) {
                            return _StatCard(
                              icon: Icons.receipt_long_outlined,
                              title: 'Orders',
                              value: '0',
                              iconColor: Colors.amber,
                            );
                          }

                          final orderCount = snapshot.data ?? 0;
                          print("====ordercount: $orderCount");
                          return _StatCard(
                            icon: Icons.receipt_long_outlined,
                            title: 'Orders',
                            value: orderCount.toString(),
                            iconColor: Colors.amber,
                          );
                        },
                      ),
                    ),
                  ),



                ],
              ),


              const SizedBox(height: 16),

              // Account Settings
              _SectionCard(
                title: 'Account Settings',
                children: <Widget>[
                  _SettingsTile(
                    leading: Icons.person_outline,
                    title: 'Edit Profile',
                    subtitle: 'Update your personal information',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                      );


                    },
                  ),
                  _Divider(),
                  _SettingsTile(
                    leading: Icons.password_outlined,
                    title: 'Change Password',
                    subtitle: 'Update your password',
                    onTap: () {
                     Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ChangePasswordScreen()),
                      );


                    },
                  ),

                  _Divider(),

                  _SettingsTile(
                    leading: Icons.shopping_bag_outlined,
                    title: 'My Orders',
                    subtitle: 'View your order history',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const OrdersScreen()),
                      );
                    },
                  ),
                  _Divider(),
                  _SettingsTile(
                    leading: Icons.notifications_none,
                    title: 'Notification Preferences',
                    subtitle: 'Manage your notification settings',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationSettingsPage()),
                      );



                    },
                  ),
                  _Divider(),
                  _SettingsTile(
                    leading: Icons.mail_outline,
                    title: 'Newsletter',
                    subtitle: 'Subscribe to recipe updates and offers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NewsletterScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Support & Info
              _SectionCard(
                title: 'Support & Info',
                children: <Widget>[
                  _SettingsTile(
                    leading: Icons.help_outline,
                    title: 'Help Center',
                    subtitle: 'Get answers to common questions',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpCenterScreen()),
                      );


                    },
                  ),
                  _Divider(),
                  _SettingsTile(
                    leading: Icons.info_outline,
                    title: 'About Sutter Buttes',
                    subtitle: 'Learn more about our story',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AboutScreen()),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  /*onPressed: () {
                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logout successful'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Delay slightly so the SnackBar is visible before navigating
                    Future.delayed(const Duration(milliseconds: 600), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    });
                  },*/
                  onPressed: () async {
                    // Get AuthProvider instance
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    await GoogleSignInService.signOut();
                    // Call logout method to clear token from secure storage
                    await authProvider.logout();

                    // Show success message
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Logout successful'),
                        backgroundColor: Color(0xFF7B8B57),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // Delay slightly so the SnackBar is visible before navigating
                    Future.delayed(const Duration(milliseconds: 600), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    });
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Logout'),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color iconColor;

  const _StatCard({
    required this.icon,
    required this.title,
    required this.value,
    this.iconColor = Colors.black54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F4F7), // soft tinted background
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEAD7E2)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center everything vertically
        crossAxisAlignment: CrossAxisAlignment.center, //
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, color: iconColor),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Colors.black54),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: iconColor, // 👈 Match value color with icon
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.black.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            child: Row(
              children: <Widget>[
                const Icon(Icons.settings_outlined, size: 18),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData leading;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading, color: Colors.black87),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, indent: 12, endIndent: 12);
  }
}
