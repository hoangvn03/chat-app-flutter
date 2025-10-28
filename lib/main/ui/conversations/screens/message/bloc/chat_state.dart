import 'package:chat_app/main/networks/model/converation.dart';
import 'package:chat_app/main/networks/model/message.dart';
import 'package:chat_app/main/networks/model/user.dart';

abstract class ChatState {}

class ChatLoading extends ChatState {}

class ChatSuccess extends ChatState {
  final List<MessageEntity> messages;
    List<UserModel>? typingUsers;
  final Map<int, String> userStatuses; // user_id -> status
  final bool isConnected;

  ChatSuccess({
    required this.messages,
    this.typingUsers = const [],
    this.userStatuses = const {},
    this.isConnected = true,
  });

  ChatSuccess copyWith({
    List<MessageEntity>? messages,
    List<UserModel>? typingUsers,
    Map<int, String>? userStatuses,
    bool? isConnected,
  }) {
    return ChatSuccess(
      messages: messages ?? this.messages,
      typingUsers: typingUsers ?? this.typingUsers,
      userStatuses: userStatuses ?? this.userStatuses,
      isConnected: isConnected ?? this.isConnected,
    );
  }
}

class ChatFailure extends ChatState {
  String errorMessage;
  String? errorCode;
  ChatFailure(this.errorMessage, {this.errorCode});
}
