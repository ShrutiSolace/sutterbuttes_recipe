import 'package:flutter/material.dart';
import '../../modal/cart_model.dart';
import '../../repositories/cart_repository.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repo;
  CartProvider(this._repo);

  CartModel? _cart;
  bool _loading = false;
  String? _error;

  CartModel? get cart => _cart;
  bool get isLoading => _loading;
  String? get error => _error;
  int get itemCount => _cart?.items?.fold<int>(0, (sum, it) => sum + (it.quantity ?? 0)) ?? 0;


  // Step 1: Calculate subtotal locally from items
  double _calculateLocalSubtotal() {
    if (_cart?.items == null || _cart!.items!.isEmpty) return 0.0;

    double subtotal = 0.0;
    for (final item in _cart!.items!) {
      final price = (item.price is num)
          ? (item.price as num).toDouble()
          : double.tryParse(item.price.toString()) ?? 0.0;
      final quantity = item.quantity ?? 0;
      subtotal += price * quantity;
    }
    return subtotal;
  }




  Future<void> loadCart({bool silent = false}) async {
    if (!silent) {
      _loading = true;
      _error = null;
      notifyListeners();
    }
    try {
      _cart = await _repo.getCart();
    } catch (e) {
      _error = e.toString();
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> addToCart({required int productId, required int quantity}) async {
    await _repo.addToCart(productId: productId, quantity: quantity );
    await loadCart();
  }

  Future<void> updateQuantity({
    required int productId,
    required int variationId,
    required int quantity,
  }) async {
    await _repo.updateCart(productId: productId, variationId: variationId, quantity: quantity);
    await loadCart(silent: true);
    notifyListeners();
  }

  Future<void> updateQuantityOptimistic({
    required int productId,
    required int variationId,
    required int quantity,
  }) async {
    // Optimistically update local state
    if (_cart?.items != null) {
      for (final item in _cart!.items!) {
        if ((item.productId ?? 0) == productId && (item.variationId ?? 0) == variationId) {
          item.quantity = quantity;
          break;
        }
      }

      final localSubtotal = _calculateLocalSubtotal();
      if (_cart!.totals == null) {
        _cart!.totals = Totals(subtotal: localSubtotal);
      } else {
        _cart!.totals!.subtotal = localSubtotal;
      }
      notifyListeners();

    }
    try {
      await _repo.updateCart(productId: productId, variationId: variationId, quantity: quantity);
     // await loadCart(silent: true);

    } catch (_) {
      await loadCart(silent: true);
    }

  }

  Future<void> removeItem({
    required int productId,
    required int variationId,
  }) async {
    await _repo.removeFromCart(productId: productId, variationId: variationId);
    await loadCart(silent: true);
    notifyListeners();
  }

  Future<void> removeItemOptimistic({
    required int productId,
    required int variationId,
  }) async {
    // Optimistically remove locally
    if (_cart?.items != null) {
      _cart!.items!.removeWhere((it) => (it.productId ?? 0) == productId && (it.variationId ?? 0) == variationId);
      notifyListeners();
    }
    try {
      await _repo.removeFromCart(productId: productId, variationId: variationId);
    } catch (_) {}
    await loadCart(silent: true);
  }
}


