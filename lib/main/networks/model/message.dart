import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/user.dart';

class MessageResponse {
  final MessageData data;

  MessageResponse({required this.data});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(
      data: MessageData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'data': data.toJson(),
      };
}

class MessageData {
  final List<MessageModel> messages;
  final Pagination? pagination;

  MessageData({
    required this.messages,
    this.pagination,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      messages: (json['messages'] as List?)
              ?.map((e) => MessageModel.fromJson(e))
              .toList() ??
          [],
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'messages': messages.map((e) => e.toJson()).toList(),
        if (pagination != null) 'pagination': pagination!.toJson(),
      };
}

class MessageModel {
  final int messageId;
  final int conversationId;
  final int senderId;
  final String content;
  final DateTime createdAt;
  final bool isRead;
  final UserModel? sender;
  List<Attachment>? attachments;
  List<Status>? statuses;

  MessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.content,
    required this.createdAt,
    required this.isRead,
    this.sender,
    this.attachments,
    this.statuses,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      messageId: json['message_id'] ?? 0,
      conversationId: json['conversation_id'] ?? 0,
      senderId: json['sender_id'] ?? 0,
      content: json['content'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
      sender:
          json['sender'] != null ? UserModel.fromJson(json['sender']) : null,
      attachments: (json['attachments'] as List?)
              ?.map((e) => Attachment.fromJson(e))
              .toList() ??
          [],
      statuses: (json['statuses'] as List?)
              ?.map((e) => Status.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'message_id': messageId,
        'conversation_id': conversationId,
        'sender_id': senderId,
        'content': content,
        'created_at': createdAt.toIso8601String(),
        'is_read': isRead,
        'sender': sender?.toJson(),
        'attachments': attachments!.map((e) => e.toJson()).toList(),
        'statuses': statuses!.map((e) => e.toJson()).toList(),
      };
}

class Attachment {
  Attachment();

  factory Attachment.fromJson(Map<String, dynamic> json) {
    return Attachment();
  }

  Map<String, dynamic> toJson() => {};
}

class Status {
  final int statusId;
  final int messageId;
  final int receiverId;
  final String status;
  final DateTime updatedAt;
  final Receiver? receiver;

  Status({
    required this.statusId,
    required this.messageId,
    required this.receiverId,
    required this.status,
    required this.updatedAt,
    this.receiver,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      statusId: json['status_id'] ?? 0,
      messageId: json['message_id'] ?? 0,
      receiverId: json['receiver_id'] ?? 0,
      status: json['status'] ?? '',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      receiver: json['receiver'] != null
          ? Receiver.fromJson(json['receiver'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'status_id': statusId,
        'message_id': messageId,
        'receiver_id': receiverId,
        'status': status,
        'updated_at': updatedAt.toIso8601String(),
        if (receiver != null) 'receiver': receiver!.toJson(),
      };
}

class Receiver {
  final int userId;
  final String username;

  Receiver({
    required this.userId,
    required this.username,
  });

  factory Receiver.fromJson(Map<String, dynamic> json) {
    return Receiver(
      userId: json['user_id'] ?? 0,
      username: json['username'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'username': username,
      };
}

class ChatMessage {
  final String id;
  final String fromId;
  final String fromName;
  final String text;
  final DateTime createdAt;
  final bool mine;

  ChatMessage({
    required this.id,
    required this.fromId,
    required this.fromName,
    required this.text,
    required this.createdAt,
    required this.mine,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json, String myId) {
    return ChatMessage(
      id: json['id'] ?? json['createdAt'] ?? '',
      fromId: json['fromId'] ?? '',
      fromName: json['fromName'] ?? '',
      text: json['text'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      mine: (json['fromId'] ?? '') == myId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fromId': fromId,
      'fromName': fromName,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

