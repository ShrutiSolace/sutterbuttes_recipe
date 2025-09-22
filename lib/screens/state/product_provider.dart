import 'package:flutter/material.dart';
import '../../modal/product_model.dart';
import '../../repositories/product_repository.dart';

class ProductProvider with ChangeNotifier {
  final ProductRepository _productRepository;

  ProductProvider(this._productRepository);

  List<Product> _products = [];
  bool _isLoading = false;
  String? _errorMessage;
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
}


