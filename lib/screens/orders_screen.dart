import 'package:flutter/material.dart';
import '../modal/order_list_model.dart';
import '../modal/single_order_detail_model.dart';
import '../repositories/order_repository.dart';
import '../modal/order_model.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final ScrollController _scrollController = ScrollController();
  List<OrderSummary> _orders = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  int _currentPage = 1;
  final int _perPage = 10;
  bool _hasMoreData = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadOrders();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      print("Has more data: $_hasMoreData, Current orders: ${_orders.length}");
      _loadMoreOrders();
    }
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _currentPage = 1;
      _hasMoreData = true;
    });

    try {
      final orders = await OrderRepository().getOrdersList(page: 1, perPage: _perPage);
      setState(() {
        _orders = orders;
        _isLoading = false;
        _hasMoreData = orders.length == _perPage;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _loadMoreOrders() async {
    if (_isLoadingMore || !_hasMoreData) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final nextPage = _currentPage + 1;
      final newOrders = await OrderRepository().getOrdersList(page: nextPage, perPage: _perPage);

      setState(() {
        _orders.addAll(newOrders);
        _currentPage = nextPage;
        _isLoadingMore = false;
        _hasMoreData = newOrders.length == _perPage;
      });


      // Add this line here:
      print("======++++Has more data: $_hasMoreData, Current orders: ${_orders.length}");
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refreshOrders() async {
    await _loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'My Orders',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $_error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _refreshOrders,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_orders.isEmpty) {
      return const Center(child: Text('No orders yet'));
    }

    return RefreshIndicator(
      onRefresh: _refreshOrders,
      child: ListView.separated(
        controller: _scrollController,
        padding: const EdgeInsets.all(16),
        itemCount: _orders.length + (_hasMoreData ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index == _orders.length) {
            return _buildLoadingIndicator();
          }

          final order = _orders[index];
          final created = _formatDateString(order.date);

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderDetailScreen(orderId: order.id ?? 0),
                ),
              );
            },
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
                      Text('Order #${order.id ?? 'N/A'}',
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                      _statusChip(order.status ?? '')
                    ],
                  ),
                  if (created.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(created, style: const TextStyle(color: Colors.black54)),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Order Total', style: const TextStyle(color: Colors.black54)),
                      Text('\$${order.total ?? '0.00'}',
                          style: const TextStyle(
                              color: Color(0xFFD4B25C),
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: _isLoadingMore
            ? const CircularProgressIndicator()
            : const Text('No more orders'),
      ),
    );
  }
}




//order detail screen for single order
class OrderDetailScreen extends StatefulWidget {
  final int orderId;
  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  OrderDetail? orderDetail;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _loadOrderDetail();
  }

  Future<void> _loadOrderDetail() async {
    try {
      final detail = await OrderRepository().getOrderDetail(widget.orderId);
      setState(() {
        orderDetail = detail;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Order Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Error: $error'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadOrderDetail,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (orderDetail == null) {
      return const Center(child: Text('Order not found'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOrderInfoCard(),
          const SizedBox(height: 12),
          _buildItemsCard(),
          const SizedBox(height: 12),
          _buildSummaryCard(),
        ],
      ),
    );
  }

  Widget _buildOrderInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E6EA))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Order #${orderDetail!.id}', style: const TextStyle(fontWeight: FontWeight.w800)),
              _statusChip(orderDetail!.status ?? ''),
            ],
          ),
          const SizedBox(height: 8),
          Text('Date: ${_formatDate(orderDetail!.date)}', style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildItemsCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E6EA))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         /* const Text('Items', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),*/
          Row(
            children: [
              const Text('Items', style: TextStyle(fontWeight: FontWeight.w700)),
              Text(
                orderDetail!.items != null && orderDetail!.items!.isNotEmpty
                    ? ' - QTY ${orderDetail!.items!.first.quantity ?? 0}'
                    : ' - QTY 0',
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...?orderDetail!.items?.map((item) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: item.image != null && item.image!.isNotEmpty
                      ? Image.network(
                    item.image!,
                    width: 56,
                    height: 56,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                          'assets/images/homescreen logo.png',
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover
                      );
                    },
                  )
                      : Image.asset(
                      'assets/images/homescreen logo.png',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(item.name ?? '')),
                      Text('\$${item.total ?? '0.00'}', style: const TextStyle(fontSize:15.3,fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
               /* Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                   // Text('Qty: ${item.quantity ?? 0}'),
                    Text('\$${item.total ?? '0.00'}', style: const TextStyle(fontWeight: FontWeight.w700)),
                  ],
                )*/
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    // Calculate actual subtotal from items
    double itemsSubtotal = 0.0;
    if (orderDetail!.items != null) {
      for (var item in orderDetail!.items!) {
        itemsSubtotal += double.tryParse(item.total ?? '0') ?? 0.0;
      }
    }

    double orderTotal = double.tryParse(orderDetail!.total ?? '0') ?? 0.0;
    double shipping = orderTotal - itemsSubtotal;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE8E6EA))
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _row('Subtotal:', itemsSubtotal.toStringAsFixed(2)),
          if (shipping > 0) _row('Shipping:', shipping.toStringAsFixed(2)),
          const Divider(),
          _row('Total:', orderDetail!.total ?? '0.00', bold: true),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString ?? '';
    }
  }
  // Add this method
  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text('\$$value', style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.w500)),
      ],
    );
  }
}



Widget _statusChip(String status) {
  Color color = const Color(0xFF7B8B57);
  String label = status;

  switch (status.toLowerCase()) {
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
    case 'cancelled':
      color = const Color(0xFFF44336);
      label = 'Cancelled';
      break;
    default:
      color = const Color(0xFF7B8B57);
      label = status;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16)
    ),
    child: Text(
        label,
        style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600
        )
    ),
  );
}

String _formatDateString(String? dateString) {
  if (dateString == null || dateString.isEmpty) return '';
  try {
    final dt = DateTime.tryParse(dateString);
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
