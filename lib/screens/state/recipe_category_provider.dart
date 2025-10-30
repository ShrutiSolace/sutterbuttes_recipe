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
  // pagination state for category recipes
  final int _perPage = 20;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  // expose to UI
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String get errorMessage => _errorMessage;
  List<RecipeCategory> get categories => _categories;
  bool get hasMore => _hasMore;



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
  /*Future<void> fetchRecipesByCategory(int categoryId) async {
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
  }*/

  // INITIAL load for a category (page 1, 20 items)
  Future<void> fetchRecipesByCategory(int categoryId) async {
    print("====== recipes for category ID: $categoryId");
    if (_isLoading) return;

    _isLoading = true;
    _isLoadingMore = false;
    _errorMessage = '';
    _recipes = [];
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final response = await repository.getRecipesByCategory(
        categoryId,
        page: _currentPage,
        perPage: _perPage,
      );
      print("======Fetched ${response.length} recipes for category ID: $categoryId (page $_currentPage)");
      _recipes = response;
      _hasMore = response.length == _perPage;
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // LOAD MORE for a category (next 20 items)
  Future<void> loadMoreRecipesByCategory(int categoryId) async {
    if (_isLoading || _isLoadingMore || !_hasMore) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final response = await repository.getRecipesByCategory(
        categoryId,
        page: nextPage,
        perPage: _perPage,
      );

      _recipes.addAll(response);
      _currentPage = nextPage;
      _hasMore = response.length == _perPage;
    } catch (e) {
      // keep _hasMore as-is; just stop the spinner
      _errorMessage = e.toString();
    }

    _isLoadingMore = false;
    notifyListeners();
  }
}





























