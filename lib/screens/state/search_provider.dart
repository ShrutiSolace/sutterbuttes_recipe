import 'dart:async';

import 'package:flutter/foundation.dart';
import '../../modal/search_model.dart';
import '../../repositories/search_repository.dart';


class SearchProvider extends ChangeNotifier {
  final SearchRepository _searchRepository = SearchRepository();

  List<SearchItem> _searchResults = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String _currentQuery = '';
  Timer? _debounce;


  List<SearchItem> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  String get currentQuery => _currentQuery;

  void searchItems(String query) {
    print("Searching for: $query");
    _currentQuery = query;

    // Cancel previous timer if typing fast
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.trim().isEmpty) {
        _searchResults = [];
        _currentQuery = '';
        notifyListeners();
        return;
      }

      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      try {
        final result = await _searchRepository.searchItems(query);
        // ADD THESE PRINT STATEMENTS:
        print("===  SEARCH API ===");
        print("API returned ${result.results.recipes.length} recipes");
        print("API returned ${result.results.products.length} products");
        print("Total showing: ${result.results.recipes.length + result.results.products.length}");
        print("========================");

        _searchResults = [];

        for (var recipe in result.results.recipes) {
          print('===Found recipe: ${recipe.title}');
          _searchResults.add(SearchRecipeItem.fromSearchRecipe(recipe));
        }

        for (var product in result.results.products) {
          print("====Found product: ${product.title}");

          _searchResults.add(SearchProductItem.fromSearchProduct(product));
        }

        _errorMessage = '';
      } catch (e) {
        _errorMessage = e.toString();
        _searchResults = [];
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    });
  }


  void clearSearch() {
    _searchResults = [];
    _currentQuery = '';
    _errorMessage = '';
    notifyListeners();
  }
}