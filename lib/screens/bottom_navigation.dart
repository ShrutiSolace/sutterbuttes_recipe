import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/screens/category_recipe_screen.dart';
import 'package:sutterbuttes_recipe/screens/favorites_screen.dart';
import 'package:sutterbuttes_recipe/screens/recipedetailscreen.dart';
import 'package:sutterbuttes_recipe/screens/shop_screen.dart';
import 'package:sutterbuttes_recipe/screens/state/cart_provider.dart';
import '../utils/auth_helper.dart';
import 'home_screen.dart';
import 'recipes_screen.dart';
import 'profile_screen.dart';
import 'favorites_screen.dart';
import 'all_trending_products_screen.dart';
import 'category_recipe_screen.dart';
import 'trending_screen.dart';
/*class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({super.key});

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages =  <Widget>[
    HomeScreen(),
    RecipesScreen(),
    ShopScreen(),
    FavoritesScreen(),
    ProfileScreen(),



  ];*/
class BottomNavigationScreen extends StatefulWidget {
  final int initialIndex;
  final Widget? customScreen;

  const BottomNavigationScreen({
    super.key,
    this.initialIndex = 0,
    this.customScreen,
  });

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = <Widget>[
    HomeScreen(),
    RecipesScreen(),
    ShopScreen(),
    FavoritesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    const Color selectedColor = Color(0xFF7B8B57); // subtle green like the image
    const Color unselectedColor = Color(0xFF5F6368); // grey for inactive items

    return Scaffold(
      backgroundColor: Colors.white,
      body: widget.customScreen ?? _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
       /* onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },*/
        onTap: (int index)  async {
          if (index == 3) {
            final isAuthenticated = await AuthHelper.checkAuthAndPromptLogin(
                context,
                attemptedAction: 'favorites', );
            if (!isAuthenticated) {
              return;
            }
          }


          // ADD: Check auth for Profile tab (index 4)
          if (index == 4) {
            final isAuthenticated = await AuthHelper.checkAuthAndPromptLogin(context,
            attemptedAction: 'profile', );
            if (!isAuthenticated) {
              return;
            }
          }









          setState(() {
            _currentIndex = index;
          });

          // Reload cart when switching to Home tab
          if (index == 0) {
            context.read<CartProvider>().loadCart();
          }






          if (widget.customScreen != null) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigationScreen(initialIndex: 1)),
                );
                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigationScreen(initialIndex: 2)),
                );
                break;
              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigationScreen(initialIndex: 3)),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigationScreen(initialIndex: 4)),
                );
                break;
            }
          }
        },




















        selectedItemColor: selectedColor,
        unselectedItemColor: unselectedColor,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_outlined),
            activeIcon: Icon(Icons.restaurant_menu),
            label: 'Recipes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storefront_outlined),
            activeIcon: Icon(Icons.storefront),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  final String title;
  const _TabPlaceholder({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}


