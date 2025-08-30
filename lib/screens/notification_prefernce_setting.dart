import 'package:flutter/material.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  // Email Notifications
  bool _emailNewRecipes = true;
  bool _emailOrderUpdates = true;
  bool _emailPromotions = false;
  bool _emailNewsletter = true;

  // Push Notifications
  bool _pushNewRecipes = true;
  bool _pushOrderUpdates = true;
  bool _pushPromotions = false;
  bool _pushCookingReminders = true;

  // SMS Notifications
  bool _smsOrderUpdates = false;
  bool _smsPromotions = false;

  // App Features
  bool _appFavoriteUpdates = true;
  bool _appRecipeRecommendations = true;
  bool _appSocialFeatures = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification Settings",
          style: TextStyle(color: Colors.white), // ✅ white title text
        ),
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white), // ✅ makes back arrow white
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Email Notifications'),
              _buildSettingRow(
                'New Recipes',
                'Get notified when new recipes are added',
                _emailNewRecipes,
                    (bool value) {
                  setState(() {
                    _emailNewRecipes = value;
                  });
                },
              ),
              _buildSettingRow(
                'Order Updates',
                'Receive order status and tracking updates',
                _emailOrderUpdates,
                    (bool value) {
                  setState(() {
                    _emailOrderUpdates = value;
                  });
                },
              ),
              _buildSettingRow(
                'Promotions & Deals',
                'Special offers and discount notifications',
                _emailPromotions,
                    (bool value) {
                  setState(() {
                    _emailPromotions = value;
                  });
                },
              ),
              _buildSettingRow(
                'Newsletter',
                'Weekly newsletter with cooking tips',
                _emailNewsletter,
                    (bool value) {
                  setState(() {
                    _emailNewsletter = value;
                  });
                },
              ),
              const Divider(),
              _buildSectionTitle('Push Notifications'),
              _buildSettingRow(
                'New Recipes',
                'Instant alerts for new recipe additions',
                _pushNewRecipes,
                    (bool value) {
                  setState(() {
                    _pushNewRecipes = value;
                  });
                },
              ),
              _buildSettingRow(
                'Order Updates',
                'Real time order status notifications',
                _pushOrderUpdates,
                    (bool value) {
                  setState(() {
                    _pushOrderUpdates = value;
                  });
                },
              ),
              _buildSettingRow(
                'Promotions',
                'Flash sales and special offers',
                _pushPromotions,
                    (bool value) {
                  setState(() {
                    _pushPromotions = value;
                  });
                },
              ),
              _buildSettingRow(
                'Cooking Reminders',
                'Reminders for saved recipes',
                _pushCookingReminders,
                    (bool value) {
                  setState(() {
                    _pushCookingReminders = value;
                  });
                },
              ),
              const Divider(),
              _buildSectionTitle('SMS Notifications'),
              _buildSettingRow(
                'Order Updates',
                'Text messages for order status',
                _smsOrderUpdates,
                    (bool value) {
                  setState(() {
                    _smsOrderUpdates = value;
                  });
                },
              ),
              _buildSettingRow(
                'Promotions',
                'SMS alerts for special offers',
                _smsPromotions,
                    (bool value) {
                  setState(() {
                    _smsPromotions = value;
                  });
                },
              ),
              const Divider(),
              _buildSectionTitle('App Features'),
              _buildSettingRow(
                'Favorite Updates',
                'Updates about your favorite recipes',
                _appFavoriteUpdates,
                    (bool value) {
                  setState(() {
                    _appFavoriteUpdates = value;
                  });
                },
              ),
              _buildSettingRow(
                'Recipe Recommendations',
                'Personalized recipe suggestions',
                _appRecipeRecommendations,
                    (bool value) {
                  setState(() {
                    _appRecipeRecommendations = value;
                  });
                },
              ),
              _buildSettingRow(
                'Social Features',
                'Community and sharing notifications',
                _appSocialFeatures,
                    (bool value) {
                  setState(() {
                    _appSocialFeatures = value;
                  });
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  print('Preferences saved!');
                },
                icon: const Icon(Icons.save),
                label: const Text('Save Preferences'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  // TODO: Implement reset logic here
                  setState(() {
                    _emailNewRecipes = true;
                    _emailOrderUpdates = true;
                    _emailPromotions = false;
                    _emailNewsletter = true;
                    _pushNewRecipes = true;
                    _pushOrderUpdates = true;
                    _pushPromotions = false;
                    _pushCookingReminders = true;
                    _smsOrderUpdates = false;
                    _smsPromotions = false;
                    _appFavoriteUpdates = true;
                    _appRecipeRecommendations = true;
                    _appSocialFeatures = false;
                  });
                  print('Preferences reset to defaults!');
                },
                child: const Text('Reset to Defaults'),
              ),
              const SizedBox(height: 24),
              const Text(
                'About Notifications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can change these settings at any time. Some notifications are essential for order tracking and account security. We respect your privacy and will never share your information with third parties.',
                style: TextStyle(color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.grey),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
      String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.green[700],
          ),
        ],
      ),
    );
  }
}