import 'dart:io';
import 'dart:ui';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../repositories/notifications_repository.dart';



class NotificationService {
  static const String _fcmTokenKey = 'fcm_token';


  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();



  static VoidCallback? onNotificationReceived;


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

  static Future<void> initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap
        if (onNotificationReceived != null) {
          onNotificationReceived!();
        }
      },
    );

    // Request permission for Android 13+
    if (Platform.isAndroid) {
      await _localNotifications
          .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
  }

  static void listenToForegroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Foreground message received:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      // Show local notification
      _showLocalNotification(message);  // ← ADD THIS LINE HERE


      // Trigger notification count refresh
      if (onNotificationReceived != null) {
        onNotificationReceived!();
      }



    });
  }


  static void listenToNotificationTap() {
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification tapped:");
      print("Title: ${message.notification?.title}");
      print("Body: ${message.notification?.body}");

      // Trigger notification count refresh
      if (onNotificationReceived != null) {
        onNotificationReceived!();
      }


    });
  }


  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      channelDescription: 'Notifications channel',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'New Notification',
      message.notification?.body ?? '',
      details,
    );
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


// Add these methods to the NotificationService class
  static Future<void> registerDeviceWithBackend() async {
    try {
      final String? fcmToken = await getSavedToken();
      if (fcmToken != null) {
        final repository = DeviceRegistrationRepository();
        final platform = Platform.isAndroid ? 'android' : 'ios';

        await repository.registerDevice(
          fcmToken: fcmToken,
          platform: platform,
        );
        print('Device registered successfully with backend');
      }
    } catch (e) {
      print('Failed to register device with backend: $e');
    }
  }

  static Future<void> registerDeviceOnTokenRefresh() async {
    _firebaseMessaging.onTokenRefresh.listen((String newToken) async {
      print('Token refreshed: $newToken');
      await saveToken(newToken);

      // Register the new token with backend
      try {
        final repository = DeviceRegistrationRepository();
        final platform = Platform.isAndroid ? 'android' : 'ios';

        await repository.registerDevice(
          fcmToken: newToken,
          platform: platform,
        );
        print('Refreshed token registered with backend');
      } catch (e) {
        print('Failed to register refreshed token: $e');
      }
    });
  }







}


