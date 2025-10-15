class NotificationModel {
  final int notificationId;
  final int userId;
  final String type;
  final String content;
  final DateTime createdAt;
  final bool isSeen;

  NotificationModel({
    required this.notificationId,
    required this.userId,
    required this.type,
    required this.content,
    required this.createdAt,
    required this.isSeen,
  });

  // Tạo đối tượng từ JSON
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      notificationId: json['notification_id'] is int
          ? json['notification_id']
          : int.parse(json['notification_id'].toString()),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.parse(json['user_id'].toString()),
      type: json['type'] ?? '',
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()),
      isSeen: json['is_seen'].toString() == '1' || json['is_seen'] == true,
    );
  }

  // Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'notification_id': notificationId,
      'user_id': userId,
      'type': type,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_seen': isSeen ? 1 : 0, // hoặc true/false tùy theo API backend
    };
  }
}
