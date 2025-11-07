import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:sutterbuttes_recipe/api_constant.dart';
import '../repositories/cart_repository.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../repositories/payment_repository.dart';
import 'state/cart_provider.dart';
import 'order_success_screen.dart';
import '../modal/check_out_model.dart';
import '../repositories/profile_repository.dart';


class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _sameAsBilling = false;
  List<Map<String, dynamic>>? _savedCartItems;


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
  final _sPhone = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadBillingInfo();


    // Refresh cart data when checkout screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CartProvider>().loadCart();
    });


    // Listen to billing changes
    _bFirst.addListener(_syncShippingWithBilling);
    _bLast.addListener(_syncShippingWithBilling);
    _bAddress.addListener(_syncShippingWithBilling);
    _bCity.addListener(_syncShippingWithBilling);
    _bState.addListener(_syncShippingWithBilling);
    _bZip.addListener(_syncShippingWithBilling);
    _bPhone.addListener(_syncShippingWithBilling);
  }









  bool _submitting = false;
  bool _paymentSuccessful = false;
  Map<String, dynamic>? paymentIntentData;
 // String _selectedPaymentMethod = 'cod';
  String _selectedPaymentMethod = 'stripe';
  double? _shippingTotal;
  double? _finalTotal;
  static const double _defaultShippingCost = 10.95;

  void _syncShippingWithBilling() {
    if (_sameAsBilling) {
      setState(() {
        _sFirst.text = _bFirst.text;
        _sLast.text = _bLast.text;
        _sAddress.text = _bAddress.text;
        _sCity.text = _bCity.text;
        _sState.text = _bState.text;
        _sZip.text = _bZip.text;
        _sPhone.text = _bPhone.text;
      });
    }
  }

  // Calculate and update default shipping if subtotal < 100
  void _updateDefaultShipping(double subtotalValue) {
    // Only set default shipping if subtotal < 100 and shipping hasn't been set from order placement
    if (subtotalValue > 0 && subtotalValue < 100 && _shippingTotal == null) {
      setState(() {
        _shippingTotal = _defaultShippingCost;
        _finalTotal = subtotalValue + _defaultShippingCost;
      });
    }
    // Clear default shipping if subtotal >= 100
    else if (subtotalValue >= 100 && _shippingTotal == _defaultShippingCost) {
      setState(() {
        _shippingTotal = null;
        _finalTotal = null;
      });
    }
  }



  Future<void> _loadBillingInfo() async {
    print("Fetching the billing info");
    try {
      final repo = UserRepository();
      final userData = await repo.getUserProfileData();

      setState(() {
        _bFirst.text = userData.firstName ?? '';
        _bLast.text = userData.lastName ?? '';
        _bEmail.text = userData.email ?? '';
        _bPhone.text = userData.phone ?? '';
        _bAddress.text = userData.streetAddress ?? '';
        _bCity.text = userData.city ?? '';
        _bState.text = userData.state ?? '';
        _bZip.text = userData.zipcode ?? '';
      });
    } catch (e) {
      print('Error loading billing info: $e');
       SnackBar(content: Text('Failed to load billing information'));

    }
  }

  @override
  void dispose() {
    _bFirst.removeListener(_syncShippingWithBilling);
    _bLast.removeListener(_syncShippingWithBilling);
    _bAddress.removeListener(_syncShippingWithBilling);
    _bCity.removeListener(_syncShippingWithBilling);
    _bState.removeListener(_syncShippingWithBilling);
    _bZip.removeListener(_syncShippingWithBilling);
    _bPhone.removeListener(_syncShippingWithBilling);


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
    _sPhone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>().cart;
    final subtotal = cart?.totals?.subtotal ?? 0;


    // Convert subtotal to double for calculations
    final subtotalDouble = double.tryParse(subtotal.toString()) ?? 0.0;
    if (subtotalDouble > 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _updateDefaultShipping(subtotalDouble);
        }
      });
    }


    const brandGreen = Color(0xFF7B8B57);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Checkout",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true, // optional: centers the title nicely
      ),

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Billing Information'),
              _verticalGrid([
                _field('First Name *', _bFirst,  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))]),
                _field('Last Name *', _bLast, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))]),
                _field('Email *', _bEmail, keyboardType: TextInputType.emailAddress),
                _field('Phone *', _bPhone, keyboardType: TextInputType.phone, isPhoneField: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                _field('Address *', _bAddress, maxLines: 2, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9 ]'))]
                ),
                _field('City *', _bCity, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))]),
                _field('State *', _bState, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z ]'))]),
                _field('ZIP Code *', _bZip, keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],
                ),
              ]),


              const SizedBox(height: 16),

              // Same as billing checkbox
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: CheckboxListTile(
                  title: const Text(
                    'Same as Billing Address',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF4A3D4D),
                    ),
                  ),
                  value: _sameAsBilling,
                  onChanged: _onSameAsBillingChanged,
                  activeColor: const Color(0xFF7B8B57),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                ),
              ),

              const SizedBox(height: 8),
              _sectionTitle('Shipping Information'),
              _verticalGrid([
                _field('First Name *', _sFirst , enabled: !_sameAsBilling),
                _field('Last Name *', _sLast, enabled: !_sameAsBilling),
                _field('Phone *', _sPhone,
                  enabled: !_sameAsBilling,
                  keyboardType: TextInputType.phone,
                  isPhoneField: true,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                ),
                _field('Address *', _sAddress, maxLines: 2,enabled: !_sameAsBilling),
                _field('City *', _sCity,enabled: !_sameAsBilling),
                _field('State *', _sState,enabled: !_sameAsBilling),
                _field('ZIP Code *', _sZip, keyboardType: TextInputType.number,enabled: !_sameAsBilling,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(5),
                  ],),
              ]),

              const SizedBox(height: 16),
              _sectionTitle('Payment Information'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                  /*  RadioListTile<String>(
                      value: 'cod',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (v) => setState(() => _selectedPaymentMethod = v ?? 'cod'),
                      title: const Text('Cash on Delivery'),
                      activeColor: Color(0xFF7B8B57),
                      dense: true,
                    ),*/
                    const Divider(height: 1),
                    RadioListTile<String>(
                      value: 'stripe',
                      groupValue: _selectedPaymentMethod,
                      onChanged: (v) => setState(() => _selectedPaymentMethod = v ?? 'stripe'),
                      title: const Text('Stripe'),
                      activeColor: Color(0xFF7B8B57),
                      dense: true,
                    ),
                  ],
                ),
              )
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

           /*
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: const TextStyle(fontWeight: FontWeight.w600)),
               // Text('\$$subtotal', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
                Text('\$${double.tryParse(subtotal.toString())?.toStringAsFixed(2) ?? subtotal.toString()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
              ],
            ),
            */
            // Subtotal Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('\$${double.tryParse(subtotal.toString())?.toStringAsFixed(2) ?? subtotal.toString()}', style: const TextStyle(fontWeight: FontWeight.w500)),
              ],
            ),

            // Shipping Row (only show if shipping > 0)
            if (_shippingTotal != null && _shippingTotal! > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping:', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text('\$${_shippingTotal!.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),

            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Divider(),
            ),

            // Total Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total:', style: const TextStyle(fontWeight: FontWeight.w600)),
                //Text('\$${(_finalTotal ?? double.tryParse(subtotal.toString()) ?? 0.0).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
                Text('\$${(_finalTotal ?? (subtotalDouble + (subtotalDouble < 100 ? (_shippingTotal ?? _defaultShippingCost) : 0.0))).toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD4B25C))),
              ],
            ),
            const SizedBox(height: 8),












            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _submitting
                  ? null
                  : () async {
                // Save cart items before checkout (in case payment fails)
                final cartProvider = context.read<CartProvider>();
                final cart = cartProvider.cart;
                if (cart?.items != null) {
                  _savedCartItems = cart!.items!.map((item) => {
                    'product_id': item.productId ?? 0,
                    'variation_id': item.variationId ?? 0,
                    'quantity': item.quantity ?? 0,
                  }).toList();
                }

                      final method = _selectedPaymentMethod;
                      final resp = await _placeOrder(paymentMethod: method);
                      if (resp == null) return;

                       await makePayment(resp);
                    },
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



  Widget _verticalGrid(List<Widget> fields) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        children: fields
            .map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: w,
                ))
            .toList(),
      ),
    );
  }


  Widget _field(
      String label,
        TextEditingController controller,
        {TextInputType? keyboardType, int maxLines = 1,
        bool isPhoneField = false,
        List<TextInputFormatter>? inputFormatters,
        bool enabled = true,}) {

    return TextFormField(
      controller: controller,
      enabled: enabled,
      keyboardType: keyboardType,
      maxLines: maxLines,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
      validator: (v) {
        if (!enabled) return null;
        if (v == null || v.trim().isEmpty) {
          return 'Please enter required fields';
        }

        if (v == null || v.trim().isEmpty) {
          return 'Please enter required fields';
        }

        if (label.contains('First Name')) {
          if (v.trim().isEmpty) {
            return 'Please enter your first name';
          }
          if (v.trim().length < 2) {
            return 'First name must be at least 2 characters';
          }
          if (v.trim().length > 50) {
            return 'First name must be less than 50 characters';
          }
        }

        if (label.contains('Last Name')) {
          if (v.trim().isEmpty) {
            return 'Please enter your last name';
          }
          if (v.trim().length < 2) {
            return 'Last name must be at least 2 characters';
          }
          if (v.trim().length > 50) {
            return 'Last name must be less than 50 characters';
          }
        }

        // Phone number validation
        if (isPhoneField) {
          // Remove all non-digit characters for validation
          String digitsOnly = v.replaceAll(RegExp(r'[^\d]'), '');
          if (digitsOnly.length < 10) {
            return 'Phone number must be at least 10 digits';
          }
        }

        // Email validation
        if (label.contains('Email')) {
          final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
          if (!emailRegex.hasMatch(v.trim())) {
            return 'Please enter a valid email address';
          }
        }
        if (label.contains('Address')) {
          if (v.trim().length < 10) {
            return 'Address must be at least 10 characters';
          }
          if (v.trim().length > 100) {
            return 'Address must be less than 100 characters';
          }
        }

        // ZIP code validation
        if (label.contains('ZIP')) {
          String digitsOnly = v.replaceAll(RegExp(r'[^\d]'), '');
          if (digitsOnly.length != 5 && digitsOnly.length != 9) {
            return 'ZIP code must be 5 or 9 digits';
          }
        }

        // State validation
        if (label.contains('State')) {
          if (v.trim().length < 2) {
            return 'State must be at least 2 characters';
          }
          if (v.trim().length > 50) {
            return 'State must be less than 50 characters';
          }
        }

        // City validation
        if (label.contains('City')) {
          if (v.trim().length < 2) {
            return 'City must be at least 2 characters';
          }
          if (v.trim().length > 50) {
            return 'City must be less than 50 characters';
          }
        }

        return null;
      },
    );
  }


  void _onSameAsBillingChanged(bool? value) {
    setState(() {
      _sameAsBilling = value ?? false;
      if (_sameAsBilling) {
        // Copy billing data to shipping
        _sFirst.text = _bFirst.text;
        _sLast.text = _bLast.text;
        _sAddress.text = _bAddress.text;
        _sCity.text = _bCity.text;
        _sState.text = _bState.text;
        _sZip.text = _bZip.text;
        _sPhone.text= _bPhone.text;
      } else {
        // Clear shipping fields
        _sFirst.clear();
        _sLast.clear();
        _sAddress.clear();
        _sCity.clear();
        _sState.clear();
        _sZip.clear();
        _sPhone.clear();
      }
    });
  }

  Future<void> makePayment(Map<String, dynamic> data) async {
    try {
      final clientSecret = data['client_secret'];
      final orderId = data['order_id'];
      final paymentIntentId = data['payment_intent_id'];

      if (clientSecret == null || clientSecret.isEmpty) {
        throw Exception("Missing client_secret from backend");
      }

      print("====== Initialize the payment sheet");

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'My Store',
          style: ThemeMode.system,
          allowsDelayedPaymentMethods: true,
          billingDetails: BillingDetails(
            address: Address(
              line1: _bAddress.text,
              line2: _bState.text,
              city: _bCity.text,
              country: 'US',
              state: _bState.text,
              postalCode: _bZip.text,
            ),
          ),
          ),
        );


      print("====== Show the payment sheet");

      try {

        await Stripe.instance.presentPaymentSheet();

        print("====== Payment sheet closed successfully");
        print("====== Notify your backend to confirm payment");

        setState(() => _submitting = true);
        bool value = false;
        try {
          value = await PaymentRepository().createStripePaymentIntent(orderId: orderId, paymentIntentId: paymentIntentId);
        } finally {
          if (mounted) setState(() => _submitting = false);
        }

      /*  if (value) {
          await context.read<CartProvider>().loadCart();  // <— ADD HERE
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful'),
             ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
          );
        }
*/
        if (value) {
          setState(() {
            _paymentSuccessful = true;  // Add this line
          });
          await context.read<CartProvider>().loadCart();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Payment successful'),
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OrderSuccessScreen()),
          );
        }


        else {
          throw Exception('Payment confirmation failed on backend');
        }
      } on StripeException catch (e) {
        print("====== StripeException: ${e.error.localizedMessage}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment cancelled: ${e.error.localizedMessage}')),
        );
        await _restoreCartItems();
        if (mounted) {
          Navigator.pop(context);
        }

      } catch (e) {
        print("====== Unexpected payment error: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment failed: $e')),
        );

        await _restoreCartItems();
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      print("====== makePayment() exception: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment initialization failed: $e')),
      );

      await _restoreCartItems();
      if (mounted) {
        Navigator.pop(context); // Go back to cart screen
      }
    }
  }


  Future<void> _restoreCartItems() async {
    if (_savedCartItems == null || _savedCartItems!.isEmpty) return;

    try {
      final cartRepo = CartRepository();
      // Restore each item using updateCart API
      for (var item in _savedCartItems!) {
        await cartRepo.addToCart(
          productId: item['product_id'] as int,
          quantity: item['quantity'] as int,
        );
      }
      // Reload cart to update UI
      await context.read<CartProvider>().loadCart();
      // Clear saved items
      _savedCartItems = null;
    } catch (e) {
      print('Error restoring cart items: $e');
    }
  }















  Future<Map<String, dynamic>?> _placeOrder({required String paymentMethod}) async {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return null;
    setState(() {
      _submitting = true;
    });
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
          'phone': _sPhone.text.trim(),
        },
        paymentMethod: paymentMethod,
      );
      //calculate shipping and total
      final checkoutData = CheckOutModel.fromJson(resp);
      final shippingValue = checkoutData.shippingTotal ?? '0';
      final totalValue = checkoutData.total ?? '0';

      setState(() {
        _shippingTotal = double.tryParse(shippingValue) ?? 0.0;
        _finalTotal = double.tryParse(totalValue) ?? 0.0;
      });
      // Refresh cart count post-order
      //await context.read<CartProvider>().loadCart();

      return resp;
    } on StripeException catch (e) {
      print("======== StripeException: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Payment cancelled')));
    } catch (e) {
      print("======== catch Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Checkout failed: $e')));
    } finally {
      if (mounted)
        setState(() {
          _submitting = false;
        });
    }
  }
}
