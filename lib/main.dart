import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/repositories/newsletter_repository.dart';
import 'package:sutterbuttes_recipe/repositories/recipe_category_repository.dart';
import 'package:sutterbuttes_recipe/repositories/recipe_list_repository.dart';
import 'package:sutterbuttes_recipe/screens/state/auth_provider.dart';
import 'package:sutterbuttes_recipe/screens/state/newsletter_provider.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_category_provider.dart';
import 'package:sutterbuttes_recipe/screens/state/recipe_list_provider.dart';
import 'package:sutterbuttes_recipe/screens/state/cart_provider.dart';
import 'repositories/cart_repository.dart';
import 'package:sutterbuttes_recipe/services/notification_service.dart';
import 'screens/login_screen.dart';
import 'screens/bottom_navigation.dart';
import 'screens/signup_screen.dart';
import 'screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_branch_sdk/flutter_branch_sdk.dart';


   @pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
}


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print('Starting Firebase initialization...');

  await FlutterBranchSdk.init();

  try {
    await Firebase.initializeApp();
    await NotificationService.requestPermission();
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    await NotificationService.getToken();
    NotificationService.listenToForegroundMessages();
    NotificationService.listenToNotificationTap();

    print('Firebase initialized successfully!');

  } catch (e) {
    print('Firebase initialization failed: $e');
  }

  runApp(MyApp());

}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RecipeProvider(RecipeListRepository()),
        ),

        ChangeNotifierProvider<AuthProvider>(
          create: (_) {
            final authProvider = AuthProvider();
            // Restore auth state when app starts
            authProvider.restoreAuthState();
            return authProvider;
          },
        ),
        /*ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),*/

        ProxyProvider<AuthProvider, RecipeCategoryRepository>(
          update: (context, auth, previous) {
            final token = auth.token ?? '';
            return RecipeCategoryRepository();
          },
        ),

        ChangeNotifierProxyProvider<RecipeCategoryRepository, RecipeCategoryProvider>(
          create: (_) => RecipeCategoryProvider(repository: RecipeCategoryRepository()),
          update: (context, repo, previous) => RecipeCategoryProvider(repository: repo),
        ),

        ChangeNotifierProvider(
          create: (_) => NewsletterProvider(NewsletterRepository()),
        ),

        ChangeNotifierProvider(
          create: (_) => CartProvider(CartRepository()),
        ),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        title: 'Sutter Buttes',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => const BottomNavigationScreen(),
          '/signup': (BuildContext context) => const SignupScreen(),
          '/login': (BuildContext context) => const LoginScreen(),
        },
      ),
    );
  }
}

// Removed the default counter screen and replaced it with BottomNavigationScreen as the app home.
