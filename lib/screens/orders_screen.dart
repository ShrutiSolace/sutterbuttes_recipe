import 'package:flutter/material.dart';
import 'package:sutterbuttes_recipe/screens/product_detailscreen.dart';
import '../modal/order_list_model.dart';
import '../modal/single_order_detail_model.dart';
import '../repositories/order_repository.dart';
import '../modal/order_model.dart';
import '../repositories/product_repository.dart';



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
      backgroundColor: Colors.white,
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please try again',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _refreshOrders,
                child: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B8B57),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
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
                border: Border.all(color: Colors.black.withOpacity(0.2), width: 1),
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
      backgroundColor:  Colors.white,
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
      String message = 'Please try again';
      if (error!.contains('503')) {
        message = '';
      } else if (error!.contains('507')) {
        message = '';
      } else if (error!.contains('timeout') || error!.contains('network')) {
        message = 'No internet connection. Please check your network.';
      }

      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadOrderDetail,
                child: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF7B8B57),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
              ),
            ],
          ),
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
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 1)
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
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 1)
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
                    ? ' - QTY ${orderDetail!.items!.fold<int>(0, (sum, item) => sum + (item.quantity ?? 0))}'
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

                GestureDetector(
                  onTap: () async {
                    if (item.id != null) {
                      // Show loading indicator
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );

                      try {
                        final productRepository = ProductRepository();
                        final product = await productRepository.getProductDetail(item.id!);

                        if (context.mounted) {
                          Navigator.pop(context); // Close loading dialog
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(product: product),
                            ),
                          );
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(context); // Close loading dialog
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Failed to load product details: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    }
                  },
                  child: ClipRRect(
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
                ),

                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                if (item.id != null) {
                                  // Show loading indicator
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  );

                                  try {
                                    final productRepository = ProductRepository();
                                    final product = await productRepository.getProductDetail(item.id!);

                                    if (context.mounted) {
                                      Navigator.pop(context); // Close loading dialog
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetailScreen(product: product),
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Failed to load product details: $e'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              },
                              child: Text(
                                '${item.name ?? ''}',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),
                          Text(
                            '\$${(double.tryParse(item.total ?? '0') ?? 0.0).toStringAsFixed(2)}',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '\$${item.unit_price ?? ''} * ${item.quantity ?? 0}',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                      ),
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
          border: Border.all(color: Colors.black.withOpacity(0.2), width: 1)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          _row('Subtotal:', itemsSubtotal.toStringAsFixed(2),bold: true),
        //  if (shipping > 0) _row('Shipping:', shipping.toStringAsFixed(2)),

          if (itemsSubtotal >= 100)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shipping:', style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Free Shipping', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF7B8B57))),
                ],
              ),
            )
          else if (shipping > 0)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _row('Shipping:', shipping.toStringAsFixed(2),bold: true),
            ),
          const Divider(),
          _row('Total:', orderDetail!.total ?? '0.00', bold: true),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {

        print("API DATE format");
        print('Current PST time: ${DateTime.now().toUtc().subtract(Duration(hours: 8))}');

      final date = DateTime.parse(dateString);

      const months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];


        int hour12 = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
        String amPm = date.hour < 12 ? 'AM' : 'PM';

        return '${months[date.month - 1]} ${date.day}, ${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $amPm PST';
    } catch (e) {
      return dateString ?? '';
    }
  }
  // Add this method
  Widget _row(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
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

    print("API DATE format");
    print('Current PST time: ${DateTime.now().toUtc().subtract(Duration(hours: 8))}');

    final date = DateTime.parse(dateString);

    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

  int hour12 = date.hour == 0 ? 12 : (date.hour > 12 ? date.hour - 12 : date.hour);
  String amPm = date.hour < 12 ? 'AM' : 'PM';

  return '${months[date.month - 1]} ${date.day}, ${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')} $amPm PST';
  } catch (e) {
    return dateString ?? '';
  }
}