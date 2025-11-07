
class MarkReadResponse {
  final bool success;
  final String message;
  final int notificationId;

  MarkReadResponse({
    required this.success,
    required this.message,
    required this.notificationId,
  });

  factory MarkReadResponse.fromJson(Map<String, dynamic> json) {
    return MarkReadResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      notificationId: json['notification_id'] ?? 0,
    );
  }
}
