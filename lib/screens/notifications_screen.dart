import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../repositories/notifications_repository.dart';
import '../modal/notifications_list_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final DeviceRegistrationRepository _notificationsRepository = DeviceRegistrationRepository();
  List<NotificationItem> _notifications = [];
  bool _isLoading = false;
  String? _error;

  final Set<int> _markedAsReadIds = {}; // Track read IDs

  @override
  void initState() {
    super.initState();
    _loadReadIds(); // Load previously marked-as-read notifications
  }

  // 🔹 Load saved read notification IDs from SharedPreferences
  Future<void> _loadReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIds = prefs.getStringList('readNotificationIds') ?? [];
    _markedAsReadIds.addAll(savedIds.map(int.parse));
    _loadNotifications();
  }

  // 🔹 Save read notification IDs to SharedPreferences
  Future<void> _saveReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'readNotificationIds',
      _markedAsReadIds.map((id) => id.toString()).toList(),
    );
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await _notificationsRepository.getNotifications();
      final fetched = response.notifications ?? [];

      for (var notification in fetched) {
        final status = notification.status?.toLowerCase();

        // If API or local saved data indicates it's read
        if (notification.markedAsRead == true ||
            notification.markedAsRead == true ||
            status == 'read' ||
            status == 'success' ||
            (notification.id != null && _markedAsReadIds.contains(notification.id))) {
          notification.markedAsRead = true;
          notification.status = 'read';
          if (notification.id != null) _markedAsReadIds.add(notification.id!);
        }
      }

      await _saveReadIds(); // Save again in case new ones got marked from API

      setState(() {
        _notifications = fetched;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(int notificationId, int index) async {
    try {
      await _notificationsRepository.markAsRead(notificationId);

      _markedAsReadIds.add(notificationId);
      await _saveReadIds();

      setState(() {
        _notifications[index].markedAsRead = true;
        _notifications[index].status = 'read';
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Marked as read'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A3D4D),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            fontFamily: 'Roboto',
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
            Text(
              'Error: $_error',
              style: TextStyle(color: Colors.red[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadNotifications,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (_notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No notifications available',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadNotifications,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationCard(
            notification: notification,
            onMarkAsRead: () => _markAsRead(notification.id!, index),
          );
        },
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onMarkAsRead;

  const _NotificationCard({
    required this.notification,
    required this.onMarkAsRead,
  });

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final dateTime = DateTime.parse(dateString);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateString;
    }
  }

  bool _isNewNotification() {
    if (notification.status == null || notification.status!.isEmpty) {
      return false;
    }
    final status = notification.status!.toLowerCase();
    return status == 'new' || status == 'unread' || status == '0';
  }

  @override
  Widget build(BuildContext context) {
    final isNew = _isNewNotification();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isNew ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isNew ? Border.all(color: Colors.blue.shade200, width: 1.5) : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Topic and button row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  notification.topic ?? 'No Topic',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A3D4D),
                  ),
                ),
              ),
              if (notification.markedAsRead != true &&
                  notification.status?.toLowerCase() != 'read' &&
                  notification.status?.toLowerCase() != 'success')
                TextButton.icon(
                  onPressed: onMarkAsRead,
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text(
                    'Mark as Read',
                    style: TextStyle(fontSize: 12),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            notification.message ?? 'No Message',
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          const SizedBox(height: 8),
          Text(
            _formatDate(notification.date),
            style: TextStyle(fontSize: 12, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }
}
