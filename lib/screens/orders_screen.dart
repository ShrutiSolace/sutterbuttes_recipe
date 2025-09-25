import 'package:flutter/material.dart';
import '../repositories/order_repository.dart';
import '../modal/order_model.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        title: const Text('My Orders', style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: OrderRepository().getOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load orders ${snapshot.error}'));
          }
          final orders = snapshot.data ?? <OrderModel>[];
          if (orders.isEmpty) {
            return const Center(child: Text('No orders yet'));
          }
           return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: orders.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final o = orders[index];
              final itemsCount = o.lineItems?.fold<int>(0, (s, it) => s + (it.quantity ?? 0)) ?? 0;
               final created = _formatDateString(o.dateCreated);
               final lines = o.lineItems ?? <LineItems>[];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderDetailScreen(order: o))),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE8E6EA)),
                  ),
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order #${o.number ?? o.id}', style: const TextStyle(fontWeight: FontWeight.w800)),
                          _statusChip(o.status ?? '')
                        ],
                      ),
                       if (created.isNotEmpty) ...[
                         const SizedBox(height: 4),
                         Text(created, style: const TextStyle(color: Colors.black54)),
                       ],
                       const SizedBox(height: 10),
                       if (lines.isNotEmpty) ...[
                         ...lines.take(2).map((li) => Padding(
                           padding: const EdgeInsets.only(bottom: 6),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Expanded(
                                 child: Text('${li.quantity ?? 0}x ${li.name ?? ''}',
                                     maxLines: 1, overflow: TextOverflow.ellipsis,
                                     style: const TextStyle(fontSize: 14)),
                               ),
                               Text('\$${li.total ?? '0.00'}', style: const TextStyle(fontSize: 14)),
                             ],
                           ),
                         )),
                         if (lines.length > 2) const Divider(height: 20),
                       ],
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                           Text('$itemsCount items', style: const TextStyle(color: Colors.black54)),
                          Text('\$${o.total ?? '0.00'}', style: const TextStyle(color: Color(0xFFD4B25C), fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        elevation: 0,
        title: const Text('Order Details', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8E6EA))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order #${order.number ?? order.id}', style: const TextStyle(fontWeight: FontWeight.w800)),
                      _statusChip(order.status ?? ''),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text('Items', style: TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 8),
                  ...?order.lineItems?.map((li) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: li.image != null && li.image!.src != null &&  li.image!.src!.isNotEmpty
                                  ? Image.network(li.image!.src!, width: 56, height: 56, fit: BoxFit.cover)
                                  : Image.asset('assets/images/homescreen logo.png', width: 56, height: 56, fit: BoxFit.cover),
                            ),
                            const SizedBox(width: 12),
                            Expanded(child: Text(li.name ?? '')),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Qty: ${li.quantity ?? 0}'),
                                Text('\$${li.total}', style: const TextStyle(fontWeight: FontWeight.w700)),
                              ],
                            )
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _infoCard('Shipping Address', _address(order.shipping)),
            const SizedBox(height: 12),
            _infoCard('Payment Information', 'Payment Method: ${order.paymentMethodTitle != null && order.paymentMethodTitle!.isNotEmpty ? order.paymentMethodTitle : order.paymentMethod}\nBilling Address: ${_address(order.billing)}'),
            const SizedBox(height: 12),
            _summaryCard(order),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8E6EA))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w700)), const SizedBox(height: 8), Text(content)])
    );
  }

  Widget _summaryCard(OrderModel o) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE8E6EA))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _row('Subtotal:', o.total ?? '0.00'),
          _row('Shipping:', o.shippingTotal ?? '0.00'),
          _row('Tax:', o.totalTax ?? '0.00'),
          const Divider(),
          _row('Total:', o.total ?? '0.00', bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('\$$value', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }

  String _address(dynamic addr) {
    if (addr == null) return '';
    final parts = [addr.address1, addr.city, addr.state, addr.postcode, addr.country].where((e) => e != null && (e as String).isNotEmpty).join(', ');
    return parts;
  }
}

Widget _statusChip(String status) {
  Color color = const Color(0xFF7B8B57);
  String label = status;
  switch (status) {
    case 'completed':
      color = const Color(0xFF4CAF50);
      label = 'Delivered';
      break;
    case 'processing':
      color = const Color(0xFFFFC107);
      label = 'Processing';
      break;
    case 'pending':
      color = const Color(0xFF2196F3);
      label = 'Pending';
      break;
  }
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(16)),
    child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
  );
}


String _formatDateString(String? iso) {
  if (iso == null || iso.isEmpty) return '';
  try {
    final dt = DateTime.tryParse(iso);
    if (dt == null) return '';
    const months = [
      'January','February','March','April','May','June',
      'July','August','September','October','November','December'
    ];
    final m = months[dt.month - 1];
    return '$m ${dt.day}, ${dt.year}';
  } catch (_) {
    return '';
  }
}



