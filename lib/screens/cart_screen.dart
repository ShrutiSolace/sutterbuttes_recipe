import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/cart_provider.dart';
import 'checkout_screen.dart';
//convert state full wiget
class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Refresh cart data when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });
  }

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
                          Text(
                            '\$${(item.price is num ? (item.price as num).toDouble() : double.tryParse(item.price.toString()) ?? 0).toStringAsFixed(2)}',
                            style: const TextStyle(color: Color(0xFFD4B25C), fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      /*    onPressed: () async {
                            await context.read<CartProvider>().removeItemOptimistic(
                                  productId: item.productId ?? 0,
                                  variationId: item.variationId ?? 0,
                                );
                            // 🔄 Immediate refresh to make sure totals update visually right away
                            await context.read<CartProvider>().loadCart(silent: true);
                          },*/
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Remove Item'),
                                content: const Text('Are you sure you want to remove this item from your cart?'),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7B8B57)),
                                    child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );

                            if (confirm == true) {
                              await context.read<CartProvider>().removeItemOptimistic(
                                productId: item.productId ?? 0,
                                variationId: item.variationId ?? 0,
                              );
                              // Remove this next line to avoid flicker:
                              //await context.read<CartProvider>().loadCart(silent: true);

                            }
                          },
                        ),







                        Row(
                          children: [
                            _QtyButton(
                                icon: Icons.remove,
                                onTap: () async {
                                 final current = item.quantity ?? 1;
                                // Allow quantity to go to 0
                                 final newQuantity = (current - 1) >= 0 ? (current - 1) : 0;
                                 await context.read<CartProvider>().updateQuantityOptimistic(
                                  productId: item.productId ?? 0,
                                  variationId: item.variationId ?? 0,
                                     quantity: newQuantity,
                                   );
                                  }
                                  ),

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
                                }
                                ),
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
                 // Text('\$$subtotal', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
                  Text('\$${double.tryParse(subtotal.toString())?.toStringAsFixed(2) ?? subtotal.toString()}', style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
                ],
              ),
              const SizedBox(height: 12),
              // AFTER:
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: (cart.items?.any((item) => (item.quantity ?? 0) <= 0) ?? false)
                      ? null  // Disable if any item has quantity 0 or less
                      : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B8B57),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
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
