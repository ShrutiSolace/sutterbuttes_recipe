import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/modal/trending_product_model.dart';
import '../../modal/product_model.dart';
import '../../repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository ); // Modify this


  List<Product> _products = [];
  TrendingProductModel? _trendingProducts;  // Add this
  bool _isLoading = false;
  bool _isTrendingLoading = false;  // Add this for separate loading state
  String? _errorMessage;
  String? _trendingErrorMessage;


  TrendingProductModel? get trendingProducts => _trendingProducts;
  bool get isTrendingLoading => _isTrendingLoading;
  String? get trendingErrorMessage => _trendingErrorMessage;


  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Product? _product;
  Product? get product => _product;

  // Fetch all products
  Future<void> fetchProducts() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newProducts = await _productRepository.getProducts();
      _products = newProducts;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error fetching products: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear products
  void clearProducts() {
    _products = [];
    _errorMessage = null;
    notifyListeners();
  }

  // Retry fetching products..
  Future<void> retryFetchProducts() async {
    await fetchProducts();
  }


 // Fetch single product detail by ID
  Future<void> fetchProductDetail(int id) async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final product = await _productRepository.getProductDetail(id);
      _product = product;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint("Error fetching product detail: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  // Updated trending products method
  Future<void> fetchTrendingProducts() async {
    _isTrendingLoading = true;
    _trendingErrorMessage = null;
    notifyListeners();

    try {
      _trendingProducts = await _productRepository.getTrendingProducts();
    } catch (e) {
      _trendingErrorMessage = e.toString();
      debugPrint("Error fetching trending products: $e");
    } finally {
      _isTrendingLoading = false;
      notifyListeners();
    }
  }

  // Add method to clear trending products
  void clearTrendingProducts() {
    _trendingProducts = null;
    _trendingErrorMessage = null;
    notifyListeners();
  }

  // Add retry method for trending products
  Future<void> retryFetchTrendingProducts() async {
    await fetchTrendingProducts();
  }

















}


