import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../modal/recipe_category_model.dart';
import '../../repositories/recipe_category_repository.dart';
import 'package:flutter/material.dart';


class RecipeCategoryProvider extends ChangeNotifier {
  final RecipeCategoryRepository repository;

  RecipeCategoryProvider({required this.repository});

  bool _isLoading = false;
  String _errorMessage = '';
  List<RecipeCategory> _categories = [];

  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  List<RecipeCategory> get categories => _categories;

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
}