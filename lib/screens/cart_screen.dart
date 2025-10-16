import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/cart_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : (cart == null || (cart.items?.isEmpty ?? true))
              ? _EmptyCart()
              : _CartContent(),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 72, color: Colors.black26),
            const SizedBox(height: 16),
            const Text('Your cart is empty', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Add some products to get started'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B8B57)),
              child: const Text('Start Shopping', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final cart = cartProvider.cart!;

    final totalItems = cart.items?.fold<int>(0, (sum, it) => sum + (it.quantity ?? 0)) ?? 0;
    final subtotal = cart.totals?.subtotal ?? 0;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cart.items?.length ?? 0,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = cart.items![index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE8E6EA)),
                ),
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (item.image != null && item.image!.isNotEmpty)
                          ? Image.network(item.image!, width: 72, height: 72, fit: BoxFit.cover)
                          : Image.asset('assets/images/homescreen logo.png', width: 72, height: 72, fit: BoxFit.cover),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.name ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Text('\$${item.price}', style: const TextStyle(color: Color(0xFFD4B25C), fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                          onPressed: () async {
                            await context.read<CartProvider>().removeItemOptimistic(
                                  productId: item.productId ?? 0,
                                  variationId: item.variationId ?? 0,
                                );
                          },
                        ),
                        Row(
                          children: [
                            _QtyButton(
                                icon: Icons.remove,
                                onTap: () async {
                                  final current = item.quantity ?? 1;
                                  if (current <= 1) return;
                                  await context.read<CartProvider>().updateQuantityOptimistic(
                                        productId: item.productId ?? 0,
                                        variationId: item.variationId ?? 0,
                                        quantity: current - 1,
                                      );
                                }),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text('${item.quantity ?? 0}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                            _QtyButton(
                                icon: Icons.add,
                                onTap: () async {
                                  final current = item.quantity ?? 0;
                                  await context.read<CartProvider>().updateQuantityOptimistic(
                                        productId: item.productId ?? 0,
                                        variationId: item.variationId ?? 0,
                                        quantity: current + 1,
                                      );
                                }),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total ($totalItems items):', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text('\$$subtotal', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B8B57), padding: const EdgeInsets.symmetric(vertical: 14)),
                  child: const Text('Proceed to Checkout', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE0E0E0)),
          color: Colors.white,
        ),
        child: Icon(icon, size: 18, color: Colors.black54),
      ),
    );
  }
}
