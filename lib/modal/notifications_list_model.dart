class NotificationsListModel {
  NotificationsListModel({
    this.success,
    this.count,
    this.notifications,
  });

  NotificationsListModel.fromJson(dynamic json) {
    success = json['success'];
    count = json['count'];
    if (json['notifications'] != null) {
      notifications = [];
      json['notifications'].forEach((v) {
        notifications?.add(NotificationItem.fromJson(v));
      });
    }
  }
  bool? success;
  int? count;
  List<NotificationItem>? notifications;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['count'] = count;
    if (notifications != null) {
      map['notifications'] = notifications?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class NotificationItem {
  NotificationItem({
    this.topic,
    this.message,
    this.date,
    this.status,
  });

  NotificationItem.fromJson(dynamic json) {
    topic = json['topic'];
    message = json['message'];
    date = json['date'];
    status = json['status'];
  }
  String? topic;
  String? message;
  String? date;
  String? status;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['topic'] = topic;
    map['message'] = message;
    map['date'] = date;
    map['status'] = status;
    return map;
  }
}