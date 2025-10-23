import 'package:chat_app/main/networks/model/user.dart';

class ConversationResponse {
  final List<Conversation> conversations;
  final Pagination pagination;

  ConversationResponse({required this.conversations, required this.pagination});

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      conversations:
          (json['conversations'] as List)
              .map((x) => Conversation.fromJson(x))
              .toList(),
      pagination: Pagination.fromJson(json['pagination']),
    );
  }
}

class Conversation {
  final int conversationId;
  final String? conversationName;
  final bool isGroup;
  final DateTime createdAt;
  final List<UserModel> participants;
  final LastMessage? lastMessage;

  Conversation({
    required this.conversationId,
    this.conversationName,
    required this.isGroup,
    required this.createdAt,
    required this.participants,
    this.lastMessage,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      conversationId: json['conversation_id'],
      conversationName: json['conversation_name'],
      isGroup: json['is_group'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      participants:
          (json['participants'] as List)
              .map((x) => UserModel.fromJson(x))
              .toList(),
      lastMessage:
          json['last_message'] != null
              ? LastMessage.fromJson(json['last_message'])
              : null,
    );
  }
}

class LastMessage {
  final int messageId;
  final String content;
  final DateTime createdAt;
  final UserModel sender;

  LastMessage({
    required this.messageId,
    required this.content,
    required this.createdAt,
    required this.sender,
  });

  factory LastMessage.fromJson(Map<String, dynamic> json) {
    return LastMessage(
      messageId: json['message_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      sender: UserModel.fromJson(json['sender']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'message_id': messageId,
      'content': content,
      'created_at': createdAt.toIso8601String(),
      'sender': sender.toJson(),
    };
  }
}

class Pagination {
  final int currentPage;
  final int totalPages;
  final int totalCount;
  final int perPage;
  final bool hasMore;

  Pagination({
    required this.currentPage,
    required this.totalPages,
    required this.totalCount,
    required this.perPage,
    required this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      totalPages: json['total_pages'],
      totalCount: json['total_count'],
      perPage: json['per_page'],
      hasMore: json['has_more'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'total_pages': totalPages,
    'total_count': totalCount,
    'per_page': perPage,
    'has_more': hasMore,
  };
}
