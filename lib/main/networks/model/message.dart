class MessageModel {
  final int messageId;
  final int conversationId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isRead,
  });

  // Tạo đối tượng từ JSON
  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'] is int
          ? json['message_id']
          : int.parse(json['message_id'].toString()),
      conversationId: json['conversation_id'] is int
          ? json['conversation_id']
          : int.parse(json['conversation_id'].toString()),
      senderId: json['sender_id'] is int
          ? json['sender_id']
          : int.parse(json['sender_id'].toString()),
      content: json['content'] ?? '',
      createdAt: DateTime.parse(json['created_at'].toString()),
      isRead: json['is_read'].toString() == '1' || json['is_read'] == true,
    );
  }

  // Chuyển đối tượng sang JSON
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'conversation_id': conversationId,
      'sender_id': senderId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead ? 1 : 0, // hoặc true/false tùy backend
    };
  }

  // Sao chép đối tượng với thay đổi một số trường
  MessageModel copyWith({
    int? messageId,
    int? conversationId,
    int? senderId,
    String? content,
    DateTime? createdAt,
    bool? isRead,
  }) {
    return MessageModel(
      messageId: messageId ?? this.messageId,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}
class MessageStatusModel {
  final int statusId;
  final int messageId;
  final int receiverId;
  final String status;
  final DateTime updatedAt;

  MessageStatusModel({
    required this.statusId,
    required this.messageId,
    required this.receiverId,
    required this.status,
    required this.updatedAt,
  });

  // Chuyển từ JSON sang đối tượng Dart
  factory MessageStatusModel.fromJson(Map<String, dynamic> json) {
    return MessageStatusModel(
      statusId: json['status_id'] is int
          ? json['status_id']
          : int.parse(json['status_id'].toString()),
      messageId: json['message_id'] is int
          ? json['message_id']
          : int.parse(json['message_id'].toString()),
      receiverId: json['receiver_id'] is int
          ? json['receiver_id']
          : int.parse(json['receiver_id'].toString()),
      status: json['status'] ?? '',
      updatedAt: DateTime.parse(json['updated_at'].toString()),
    );
  }

  // Chuyển đối tượng Dart sang JSON
  Map<String, dynamic> toJson() {
    return {
      'status_id': statusId,
      'message_id': messageId,
      'receiver_id': receiverId,
      'status': status,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // copyWith để tạo bản sao dễ chỉnh sửa
  MessageStatusModel copyWith({
    int? statusId,
    int? messageId,
    int? receiverId,
    String? status,
    DateTime? updatedAt,
  }) {
    return MessageStatusModel(
      statusId: statusId ?? this.statusId,
      messageId: messageId ?? this.messageId,
      receiverId: receiverId ?? this.receiverId,
      status: status ?? this.status,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
