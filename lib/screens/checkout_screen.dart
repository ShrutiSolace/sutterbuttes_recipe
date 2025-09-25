import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../repositories/cart_repository.dart';
import 'state/cart_provider.dart';
import 'order_success_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  // Billing
  final _bFirst = TextEditingController();
  final _bLast = TextEditingController();
  final _bAddress = TextEditingController();
  final _bCity = TextEditingController();
  final _bState = TextEditingController();
  final _bZip = TextEditingController();
  final _bEmail = TextEditingController();
  final _bPhone = TextEditingController();
  // Shipping
  final _sFirst = TextEditingController();
  final _sLast = TextEditingController();
  final _sAddress = TextEditingController();
  final _sCity = TextEditingController();
  final _sState = TextEditingController();
  final _sZip = TextEditingController();

  bool _submitting = false;

  @override
  void dispose() {
    _bFirst.dispose();
    _bLast.dispose();
    _bAddress.dispose();
    _bCity.dispose();
    _bState.dispose();
    _bZip.dispose();
    _bEmail.dispose();
    _bPhone.dispose();
    _sFirst.dispose();
    _sLast.dispose();
    _sAddress.dispose();
    _sCity.dispose();
    _sState.dispose();
    _sZip.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    final subtotal = cart?.totals?.subtotal ?? 0;
    const brandGreen = Color(0xFF7B8B57);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        title: const Text('Checkout', style: TextStyle(color: Colors.white)),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Billing Information'),
              _grid([
                _field('First Name *', _bFirst),
                _field('Last Name *', _bLast),
                _field('Email *', _bEmail, keyboardType: TextInputType.emailAddress),
                _field('Phone *', _bPhone, keyboardType: TextInputType.phone),
                _field('Address *', _bAddress, maxLines: 2),
                _field('City *', _bCity),
                _field('State *', _bState),
                _field('ZIP Code *', _bZip, keyboardType: TextInputType.number),
              ]),

              const SizedBox(height: 16),
              _sectionTitle('Shipping Information'),
              _grid([
                _field('First Name *', _sFirst),
                _field('Last Name *', _sLast),
                _field('Address *', _sAddress, maxLines: 2),
                _field('City *', _sCity),
                _field('State *', _sState),
                _field('ZIP Code *', _sZip, keyboardType: TextInputType.number),
              ]),

              const SizedBox(height: 16),
              _sectionTitle('Payment Information'),
              const SizedBox(height: 8),
              const Text('Cash on Delivery will be used for this demo.')
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('\$$subtotal', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
              ],
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitting ? null : _placeOrder,
              style: ElevatedButton.styleFrom(backgroundColor: brandGreen, padding: const EdgeInsets.symmetric(vertical: 14)),
              child: _submitting
                  ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Place Order', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String t) => Text(t, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF4A3D4D)));

  Widget _grid(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: fields.map((w) => SizedBox(width: (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2, child: w)).toList(),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller, {TextInputType? keyboardType, int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
    );
  }

  Future<void> _placeOrder() async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;
    setState(() { _submitting = true; });
    try {
      final repo = CartRepository();
      final resp = await repo.checkout(
        billing: {
          'first_name': _bFirst.text.trim(),
          'last_name': _bLast.text.trim(),
          'address_1': _bAddress.text.trim(),
          'city': _bCity.text.trim(),
          'state': _bState.text.trim(),
          'postcode': _bZip.text.trim(),
          'country': 'US',
          'email': _bEmail.text.trim(),
          'phone': _bPhone.text.trim(),
        },
        shipping: {
          'first_name': _sFirst.text.trim(),
          'last_name': _sLast.text.trim(),
          'address_1': _sAddress.text.trim(),
          'city': _sCity.text.trim(),
          'state': _sState.text.trim(),
          'postcode': _sZip.text.trim(),
          'country': 'US',
        },
        paymentMethod: 'cod',
      );

      // Refresh cart count post-order
      await context.read<CartProvider>().loadCart();

      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const OrderSuccessScreen()));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout failed: $e')));
    } finally {
      if (mounted) setState(() { _submitting = false; });
    }
  }
}



