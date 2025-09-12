import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  static const String _fcmTokenKey = 'fcm_token';


  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  static Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Notification permission granted');
    } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
      print(' Notification permission denied');
    } else {
      print('Notification permission not determined');
    }
  }

  static Future<void> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    if (token != null) {
      await saveToken(token);
      print('FCM Token: $token');
    }

    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      print('Token refreshed: $newToken');
      await saveToken(newToken);
    });
  }

  static void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });
  }


  static void listenToNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification tapped:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");
    });
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_fcmTokenKey, token);
    print('FCM Token saved: $token');
  }

  static Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_fcmTokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_fcmTokenKey);
    print('FCM Token cleared');
  }










}


