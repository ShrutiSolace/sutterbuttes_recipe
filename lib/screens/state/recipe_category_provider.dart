import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modal/category_recipe_model.dart';
import '../../modal/recipe_category_model.dart';
import '../../repositories/recipe_category_repository.dart';
import 'package:flutter/material.dart';
import '../../modal/recipe_model.dart';

class RecipeCategoryProvider extends ChangeNotifier {
  final RecipeCategoryRepository repository;

  RecipeCategoryProvider({required this.repository});

  bool _isLoading = false;
  String _errorMessage = '';
  List<RecipeCategory> _categories = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<RecipeCategory> get categories => _categories;

  List<CategoryRecipeItem> _recipes = []; // CHANGED TYPE
  List<CategoryRecipeItem> get recipes => _recipes;  // CHANGED THIS LINE





  Future<void> fetchCategories() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final response = await repository.getRecipeCategories();
      if (response.success) {
        _categories = response.categories;
      } else {
        _errorMessage = "Something went wrong.";
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Fetch recipes by category ID
  Future<void> fetchRecipesByCategory(int categoryId) async {
    print("====== recipes for category ID: $categoryId");
    _isLoading = true;
    _errorMessage = '';
    _recipes = [];
    notifyListeners();

    try {
      final response = await repository.getRecipesByCategory(categoryId);
      print("======Fetched ${response.length} recipes for category ID: $categoryId");
      _recipes = response;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }


}


























