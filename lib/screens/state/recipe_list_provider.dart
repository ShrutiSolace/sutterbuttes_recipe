import 'package:flutter/material.dart';
import '../../modal/recipe_model.dart';
import '../../repositories/recipe_list_repository.dart';

class RecipeProvider with ChangeNotifier {
  final RecipeListRepository _recipeRepository;

  RecipeProvider(this._recipeRepository);

  List<RecipeItem> _recipes = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentPage = 1;
  final int _perPage = 10;

  List<RecipeItem> get recipes => _recipes;
  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasMoreRecipes => _recipes.length % _perPage == 0 && _recipes.isNotEmpty; // Basic check for more items

  Future<void> fetchRecipes({bool isLoadMore = false}) async {
    if (_isLoading) return;

    _isLoading = true;
    if (!isLoadMore) {
      _currentPage = 1;
      _recipes = [];
    }
    _errorMessage = null;
    notifyListeners();

    try {

      final newRecipes = await _recipeRepository.getRecipes(
          page: _currentPage, perPage: _perPage);
      _recipes.addAll(newRecipes);
      if (newRecipes.isNotEmpty) {
        _currentPage++;
      }

    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error fetching recipes: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
