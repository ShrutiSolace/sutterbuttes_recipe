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
    this.id,
    this.topic,
    this.message,
    this.date,
    this.status,
    this.markedAsRead,
  });

  NotificationItem.fromJson(dynamic json) {
    id = json['id'];
    topic = json['topic'];
    message = json['message'];
    date = json['date'];
    status = json['status'];
    markedAsRead = json['mark_as_read'] ?? json['marked_as_read'] ?? false;

  }
  int? id;
  String? topic;
  String? message;
  String? date;
  String? status;
  bool? markedAsRead;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['topic'] = topic;
    map['message'] = message;
    map['date'] = date;
    map['status'] = status;
    map['marked_as_read'] = markedAsRead;
    return map;
  }
}