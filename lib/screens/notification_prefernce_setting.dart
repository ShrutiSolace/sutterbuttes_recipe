import 'package:flutter/material.dart';
import '../repositories/notificationpref_repository.dart';
import '../modal/notification_pref_model.dart';

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

  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    setState(() { _loading = true; _error = null; });
    try {
      final model = await NotificationRepository().getPreferences();
      final p = model.preferences;
      if (p != null) {
        _emailNewRecipes = p.email?.newRecipes ?? _emailNewRecipes;
        _emailOrderUpdates = p.email?.orderUpdates ?? _emailOrderUpdates;
        _emailPromotions = p.email?.promotions ?? _emailPromotions;
        _emailNewsletter = p.email?.newsletter ?? _emailNewsletter;

        _pushNewRecipes = p.push?.newRecipes ?? _pushNewRecipes;
        _pushOrderUpdates = p.push?.orderUpdates ?? _pushOrderUpdates;
        _pushPromotions = p.push?.promotions ?? _pushPromotions;
        _pushCookingReminders = p.push?.cookingReminders ?? _pushCookingReminders;

        _smsOrderUpdates = p.sms?.orderUpdates ?? _smsOrderUpdates;
        _smsPromotions = p.sms?.promotions ?? _smsPromotions;

        _appFavoriteUpdates = p.app?.favoriteUpdates ?? _appFavoriteUpdates;
        _appRecipeRecommendations = p.app?.recipeRecommendations ?? _appRecipeRecommendations;
        _appSocialFeatures = p.app?.socialFeatures ?? _appSocialFeatures;
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      if (mounted) setState(() { _loading = false; });
    }
  }

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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Failed to load: $_error'))
              : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              /*_buildSectionTitle('Email Notifications'),
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
              ),*/
             // const Divider(),
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
              /*const Divider(),
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
              ),*/
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () async {
                  try {
                    final payload = {
                      'email': {
                        'new_recipes': _emailNewRecipes,
                        'order_updates': _emailOrderUpdates,
                        'promotions': _emailPromotions,
                        'newsletter': _emailNewsletter,
                      },
                      'push': {
                        'new_recipes': _pushNewRecipes,
                        'order_updates': _pushOrderUpdates,
                        'promotions': _pushPromotions,
                        'cooking_reminders': _pushCookingReminders,
                      },
                      'sms': {
                        'order_updates': _smsOrderUpdates,
                        'promotions': _smsPromotions,
                      },
                      'app': {
                        'favorite_updates': _appFavoriteUpdates,
                        'recipe_recommendations': _appRecipeRecommendations,
                        'social_features': _appSocialFeatures,
                      }
                    };
                    final msg = await NotificationRepository().updatePreferences(payload: payload);
                    if (!mounted) return; 
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  } catch (e) {
                    if (!mounted) return; 
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                  }
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
                onPressed: () async {
                  try {
                    final msg = await NotificationRepository().resetPreferences();
                    await _loadPrefs();
                    if (!mounted) return; 
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  } catch (e) {
                    if (!mounted) return; 
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                  }
                },
                child: const Text('Reset to Defaults'),
              ),
              const SizedBox(height: 24),
              /*const Text(
                'About Notifications',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              const Text(
                'You can change these settings at any time. Some notifications are essential for order tracking and account security. We respect your privacy and will never share your information with third parties.',
                style: TextStyle(color: Colors.black54),
              ),*/
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
